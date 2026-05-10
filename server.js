const express = require('express');
const mysql   = require('mysql2/promise');
const cors    = require('cors');
const path    = require('path');

const app  = express();
const PORT = 3000;

// ── MIDDLEWARE ────────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// ── DB CONNECTION ─────────────────────────────────────────────────────────────
const db = mysql.createPool({
  host:     'localhost',
  port:     3306,
  user:     'root',
  password: '19072006',       // ← same as db.properties
  database: 'onlinevotingsystem',
  waitForConnections: true,
  connectionLimit: 10,
});

// test connection on startup
db.getConnection()
  .then(conn => { console.log('✅ MySQL connected!'); conn.release(); })
  .catch(err => console.error('❌ MySQL connection failed:', err.message));

// ── ROUTES ────────────────────────────────────────────────────────────────────

// POST /api/login
app.post('/api/login', async (req, res) => {
  const { national_id, password } = req.body;
  if (!national_id || !password)
    return res.status(400).json({ error: 'Missing credentials' });
  try {
    const [rows] = await db.query(
      'SELECT voter_id, national_id, full_name, status FROM voter WHERE national_id = ? AND password = ?',
      [national_id, password]
    );
    if (rows.length === 0)
      return res.status(401).json({ error: 'Invalid National ID or password' });
    const user = rows[0];
    if (user.status !== 'ACTIVE')
      return res.status(403).json({ error: `Account is ${user.status}. Contact admin.` });
    res.json({ success: true, user: { id: user.voter_id, name: user.full_name, nid: user.national_id } });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/elections
app.get('/api/elections', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT election_id, election_name, start_date, end_date, status FROM election ORDER BY election_id DESC'
    );
    res.json(rows);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/elections/:id/candidates
app.get('/api/elections/:id/candidates', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT candidate_id, full_name, party_affiliation, manifesto FROM candidate WHERE election_id = ?',
      [req.params.id]
    );
    res.json(rows);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/elections/:id/results
app.get('/api/elections/:id/results', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT c.candidate_id, c.full_name, c.party_affiliation,
              COALESCE(er.total_votes, 0) AS total_votes,
              er.verified_status
       FROM candidate c
       LEFT JOIN election_result er
         ON c.candidate_id = er.candidate_id AND er.election_id = ?
       WHERE c.election_id = ?
       ORDER BY total_votes DESC`,
      [req.params.id, req.params.id]
    );
    const [elec] = await db.query(
      'SELECT election_name, start_date, end_date, status FROM election WHERE election_id = ?',
      [req.params.id]
    );
    res.json({ election: elec[0] || {}, results: rows });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/vote
app.post('/api/vote', async (req, res) => {
  const { voter_id, election_id, candidate_id } = req.body;
  if (!voter_id || !election_id || !candidate_id)
    return res.status(400).json({ error: 'Missing required fields' });
  const conn = await db.getConnection();
  try {
    await conn.beginTransaction();

    // check already voted
    const [ve] = await conn.query(
      'SELECT has_voted FROM voter_election WHERE voter_id = ? AND election_id = ?',
      [voter_id, election_id]
    );
    if (ve.length > 0 && ve[0].has_voted)
      return res.status(409).json({ error: 'You have already voted in this election.' });

    // get unused token
    const [tokens] = await conn.query(
      'SELECT token_id FROM token WHERE election_id = ? AND is_used = 0 LIMIT 1',
      [election_id]
    );
    if (tokens.length === 0)
      return res.status(400).json({ error: 'No available tokens for this election.' });
    const token_id = tokens[0].token_id;

    // get ballot
    const [ballots] = await conn.query(
      'SELECT ballot_id FROM ballot WHERE election_id = ? LIMIT 1',
      [election_id]
    );
    const ballot_id = ballots.length > 0 ? ballots[0].ballot_id : null;

    // generate encrypted vote hash
    const crypto = require('crypto');
    const enc = 'ENC:sha256$' + crypto.createHash('sha256')
      .update(`${voter_id}_${candidate_id}_${election_id}_${Date.now()}`).digest('hex');

    // insert vote
    await conn.query(
      `INSERT INTO vote (candidate_id, election_id, ballot_id, token_id, encrypted_vote, vote_timestamp)
       VALUES (?, ?, ?, ?, ?, NOW())`,
      [candidate_id, election_id, ballot_id, token_id, enc]
    );

    // consume token
    await conn.query(
      'UPDATE token SET is_used = 1, used_at = NOW() WHERE token_id = ?',
      [token_id]
    );

    // update voter_election has_voted
    await conn.query(
      `INSERT INTO voter_election (voter_id, election_id, registered_at, eligibility_status, has_voted)
       VALUES (?, ?, NOW(), 'ELIGIBLE', 1)
       ON DUPLICATE KEY UPDATE has_voted = 1`,
      [voter_id, election_id]
    );

    // update election_result
    await conn.query(
      `INSERT INTO election_result (election_id, candidate_id, total_votes, verified_status)
       VALUES (?, ?, 1, 0)
       ON DUPLICATE KEY UPDATE total_votes = total_votes + 1`,
      [election_id, candidate_id]
    );

    // audit log
    await conn.query(
      `INSERT INTO audit_log (voter_id, action_type, timestamp, details)
       VALUES (?, 'VOTE_CAST', NOW(), ?)`,
      [voter_id, `Vote recorded for candidate ${candidate_id} in election ${election_id}`]
    );

    await conn.commit();
    res.json({ success: true, message: 'Vote submitted successfully!' });
  } catch (e) {
    await conn.rollback();
    res.status(500).json({ error: e.message });
  } finally {
    conn.release();
  }
});

// GET /api/voters (admin)
app.get('/api/voters', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT voter_id, national_id, full_name, email, phone_number, registration_date, status FROM voter ORDER BY registration_date DESC'
    );
    res.json(rows);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/audit-log (admin)
app.get('/api/audit-log', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT al.log_id, v.full_name, al.action_type, al.timestamp, al.details
       FROM audit_log al
       LEFT JOIN voter v ON al.voter_id = v.voter_id
       ORDER BY al.timestamp DESC LIMIT 50`
    );
    res.json(rows);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/security-events (admin)
app.get('/api/security-events', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT se.event_id, se.event_type, se.severity, se.description,
              se.timestamp, se.ip_address, v.full_name
       FROM security_event se
       LEFT JOIN voter v ON se.voter_id = v.voter_id
       ORDER BY se.timestamp DESC`
    );
    res.json(rows);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// GET /api/stats (admin dashboard)
app.get('/api/stats', async (req, res) => {
  try {
    const [[{ total_voters }]]    = await db.query('SELECT COUNT(*) as total_voters FROM voter');
    const [[{ total_elections }]] = await db.query('SELECT COUNT(*) as total_elections FROM election');
    const [[{ total_votes }]]     = await db.query('SELECT COUNT(*) as total_votes FROM vote');
    const [[{ active_elections }]]= await db.query("SELECT COUNT(*) as active_elections FROM election WHERE status='ACTIVE'");
    res.json({ total_voters, total_elections, total_votes, active_elections });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// POST /api/change-password
app.post('/api/change-password', async (req, res) => {
  const { voter_id, current_password, new_password } = req.body;
  try {
    const [rows] = await db.query(
      'SELECT voter_id FROM voter WHERE voter_id = ? AND password = ?',
      [voter_id, current_password]
    );
    if (rows.length === 0)
      return res.status(401).json({ error: 'Current password is incorrect.' });
    await db.query('UPDATE voter SET password = ? WHERE voter_id = ?', [new_password, voter_id]);
    await db.query(
      `INSERT INTO audit_log (voter_id, action_type, timestamp, details)
       VALUES (?, 'PASSWORD_CHANGED', NOW(), 'Password changed via web UI')`,
      [voter_id]
    );
    res.json({ success: true });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// ── START ─────────────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`🚀 Server running at http://localhost:${PORT}`);
  console.log(`   Open http://localhost:${PORT} in your browser`);
});
