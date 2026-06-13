const db = require('../config/db');
const crypto = require('crypto');

exports.castVote = async (req, res) => {
  const { voter_id, election_id, candidate_id } = req.body;
  if (!voter_id || !election_id || !candidate_id)
    return res.status(400).json({ error: 'Missing required fields' });

  const conn = await db.getConnection();
  try {
    await conn.beginTransaction();

    const [tokens] = await conn.query(
      'SELECT token_id, is_used FROM token WHERE voter_id = ? AND election_id = ?',
      [voter_id, election_id]
    );
    if (tokens.length === 0)
      return res.status(400).json({ error: 'No token assigned for this election.' });
    if (tokens[0].is_used)
      return res.status(409).json({ error: 'You have already voted in this election.' });

    const token_id = tokens[0].token_id;
    const enc = 'ENC:sha256$' + crypto.createHash('sha256')
      .update(`${voter_id}_${candidate_id}_${election_id}_${Date.now()}`).digest('hex');

    await conn.query(
      `INSERT INTO vote (token_id, candidate_id, encrypted_vote, vote_timestamp)
       VALUES (?, ?, ?, NOW())`,
      [token_id, candidate_id, enc]
    );
    await conn.query(
      'UPDATE token SET is_used = 1, used_at = NOW() WHERE token_id = ?',
      [token_id]
    );
    await conn.query(
      `INSERT INTO voter_election (voter_id, election_id, registered_at, eligibility_status)
       VALUES (?, ?, NOW(), 'ELIGIBLE')
       ON DUPLICATE KEY UPDATE eligibility_status = 'ELIGIBLE'`,
      [voter_id, election_id]
    );
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
};