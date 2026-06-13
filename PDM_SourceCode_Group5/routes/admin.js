const express = require('express');
const router = express.Router();
const db = require('../config/db');

router.get('/voters', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT voter_id, national_id, full_name, email, phone_number, registration_date, status FROM voter ORDER BY registration_date DESC'
    );
    res.json(rows);
  } catch (e) { res.status(500).json({ error: e.message }); }
});

router.get('/audit-log', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT al.log_id, v.full_name, al.action_type, al.timestamp, al.details
       FROM audit_log al LEFT JOIN voter v ON al.voter_id = v.voter_id
       ORDER BY al.timestamp DESC LIMIT 50`
    );
    res.json(rows);
  } catch (e) { res.status(500).json({ error: e.message }); }
});

router.get('/security-events', async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT se.event_id, se.event_type, se.severity, se.description,
              se.timestamp, se.ip_address, v.full_name
       FROM security_event se LEFT JOIN voter v ON se.voter_id = v.voter_id
       ORDER BY se.timestamp DESC`
    );
    res.json(rows);
  } catch (e) { res.status(500).json({ error: e.message }); }
});

router.get('/stats', async (req, res) => {
  try {
    const [[{ total_voters }]]     = await db.query('SELECT COUNT(*) as total_voters FROM voter');
    const [[{ total_elections }]]  = await db.query('SELECT COUNT(*) as total_elections FROM election');
    const [[{ total_votes }]]      = await db.query('SELECT COUNT(*) as total_votes FROM vote');
    const [[{ active_elections }]] = await db.query("SELECT COUNT(*) as active_elections FROM election WHERE status='ACTIVE'");
    res.json({ total_voters, total_elections, total_votes, active_elections });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

router.post('/approve-voter', async (req, res) => {
  const { voter_id } = req.body;
  if (!voter_id) return res.status(400).json({ error: 'Missing voter_id' });
  try {
    await db.query("UPDATE voter SET status = 'ACTIVE' WHERE voter_id = ? AND status = 'PENDING'", [voter_id]);
    res.json({ success: true, message: 'Voter approved successfully.' });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

router.post('/suspend-voter', async (req, res) => {
  const { voter_id } = req.body;
  if (!voter_id) return res.status(400).json({ error: 'Missing voter_id' });
  try {
    await db.query("UPDATE voter SET status = 'SUSPENDED' WHERE voter_id = ? AND status = 'ACTIVE'", [voter_id]);
    res.json({ success: true, message: 'Voter suspended.' });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

router.post('/update-voter-status', async (req, res) => {
  const { voter_id, status } = req.body;
  if (!voter_id || !status) return res.status(400).json({ error: 'Missing fields' });
  if (!['ACTIVE','SUSPENDED','PENDING'].includes(status))
    return res.status(400).json({ error: 'Invalid status' });
  try {
    await db.query('UPDATE voter SET status = ? WHERE voter_id = ?', [status, voter_id]);
    res.json({ success: true, message: `Voter status updated to ${status}.` });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

module.exports = router;