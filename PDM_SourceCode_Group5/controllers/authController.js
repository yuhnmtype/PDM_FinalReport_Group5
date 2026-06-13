const db = require('../config/db');

exports.login = async (req, res) => {
  const { national_id, password } = req.body;
  if (!national_id || !password)
    return res.status(400).json({ error: 'Missing credentials' });
  try {
    const [rows] = await db.query(
      'SELECT voter_id, national_id, full_name, status, role FROM voter WHERE national_id = ? AND password = ?',
      [national_id, password]
    );
    if (rows.length === 0)
      return res.status(401).json({ error: 'Invalid National ID or password' });
    const user = rows[0];
    if (user.status !== 'ACTIVE')
      return res.status(403).json({ error: `Account is ${user.status}. Contact admin.` });
    res.json({ success: true, user: { id: user.voter_id, name: user.full_name, nid: user.national_id, role: user.role || 'VOTER' } });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

exports.register = async (req, res) => {
  const { full_name, national_id, email, phone_number, password } = req.body;
  if (!full_name || !national_id || !email || !password)
    return res.status(400).json({ error: 'Please fill in all required fields.' });
  if (password.length < 6)
    return res.status(400).json({ error: 'Password must be at least 6 characters.' });
  try {
    const [existing] = await db.query(
      'SELECT voter_id FROM voter WHERE national_id = ?', [national_id]
    );
    if (existing.length > 0)
      return res.status(409).json({ error: 'National ID already registered.' });
    const [existingEmail] = await db.query(
      'SELECT voter_id FROM voter WHERE email = ?', [email]
    );
    if (existingEmail.length > 0)
      return res.status(409).json({ error: 'Email already registered.' });
    await db.query(
      `INSERT INTO voter (national_id, full_name, email, phone_number, password, registration_date, status, role)
       VALUES (?, ?, ?, ?, ?, NOW(), 'PENDING', 'VOTER')`,
      [national_id, full_name, email, phone_number || null, password]
    );
    res.json({ success: true, message: 'Registration submitted. Awaiting admin approval.' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

exports.changePassword = async (req, res) => {
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
};