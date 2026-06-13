const express = require('express');
const router = express.Router();
const db = require('../config/db');

router.get('/elections', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT election_id, election_name, start_date, end_date, status FROM election ORDER BY election_id DESC'
    );
    res.json(rows);
  } catch (e) { res.status(500).json({ error: e.message }); }
});

router.get('/elections/:id/candidates', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT candidate_id, full_name, party_affiliation, manifesto FROM candidate WHERE election_id = ?',
      [req.params.id]
    );
    res.json(rows);
  } catch (e) { res.status(500).json({ error: e.message }); }
});

router.get('/elections/:id/results', async (req, res) => {
  try {
    const [elec] = await db.query('SELECT * FROM election WHERE election_id = ?', [req.params.id]);
    const [rows] = await db.query(
      `SELECT c.candidate_id, c.full_name, c.party_affiliation, COUNT(v.vote_id) as vote_count
       FROM candidate c LEFT JOIN vote v ON c.candidate_id = v.candidate_id
       WHERE c.election_id = ? GROUP BY c.candidate_id ORDER BY vote_count DESC`,
      [req.params.id]
    );
    res.json({ election: elec[0] || {}, results: rows });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

module.exports = router;