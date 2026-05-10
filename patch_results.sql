USE onlinevotingsystem;

-- ══════════════════════════════════════════════════════════════
-- PATCH: Add realistic vote distribution for all elections
-- Run this in MySQL Workbench to make results look realistic
-- ══════════════════════════════════════════════════════════════

-- Disable FK checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- ── ELECTION 20240001: National Assembly Election (VERIFIED)
-- Winner: Vo Thi Thu with 312 votes
UPDATE election_result SET total_votes = 312, verified_status = 1
WHERE election_id = 20240001 AND candidate_id = (SELECT candidate_id FROM candidate WHERE election_id = 20240001 AND full_name = 'Vo Thi Thu');

UPDATE election_result SET total_votes = 198, verified_status = 1
WHERE election_id = 20240001 AND candidate_id = (SELECT candidate_id FROM candidate WHERE election_id = 20240001 AND full_name = 'Nguyen Minh Duc');

UPDATE election_result SET total_votes = 156, verified_status = 1
WHERE election_id = 20240001 AND candidate_id = (SELECT candidate_id FROM candidate WHERE election_id = 20240001 AND full_name = 'Pham Thi Lan Anh');

-- ── ELECTION 20240002: Provincial Council Election (ACTIVE)
-- Winner: Tran Quoc Huy with 89 votes
UPDATE election_result SET total_votes = 89, verified_status = 0
WHERE election_id = 20240002 AND candidate_id = (SELECT candidate_id FROM candidate WHERE election_id = 20240002 AND full_name = 'Tran Quoc Huy');

UPDATE election_result SET total_votes = 67, verified_status = 0
WHERE election_id = 20240002 AND candidate_id = (SELECT candidate_id FROM candidate WHERE election_id = 20240002 AND full_name = 'Le Thi Phuong Linh');

-- Insert Nguyen Duc Long if 0 votes (not in table yet)
INSERT INTO election_result (election_id, candidate_id, total_votes, verified_status)
SELECT 20240002, candidate_id, 45, 0
FROM candidate WHERE election_id = 20240002 AND full_name = 'Nguyen Duc Long'
ON DUPLICATE KEY UPDATE total_votes = 45;

-- ── ELECTION 20240003: District People Committee (CLOSED)
-- Winner: Cao Thi Phuong with 127 votes
UPDATE election_result SET total_votes = 127, verified_status = 1
WHERE election_id = 20240003 AND candidate_id = (SELECT candidate_id FROM candidate WHERE election_id = 20240003 AND full_name = 'Cao Thi Phuong');

UPDATE election_result SET total_votes = 94, verified_status = 1
WHERE election_id = 20240003 AND candidate_id = (SELECT candidate_id FROM candidate WHERE election_id = 20240003 AND full_name = 'Dinh Van Hung');

UPDATE election_result SET total_votes = 71, verified_status = 1
WHERE election_id = 20240003 AND candidate_id = (SELECT candidate_id FROM candidate WHERE election_id = 20240003 AND full_name = 'Le Minh Quan');

-- ── ELECTION 20240004: Ward-Level Representative (CLOSED)
-- Winner: Bui Van Trung with 203 votes
UPDATE election_result SET total_votes = 203, verified_status = 1
WHERE election_id = 20240004 AND candidate_id = (SELECT candidate_id FROM candidate WHERE election_id = 20240004 AND full_name = 'Bui Van Trung');

UPDATE election_result SET total_votes = 145, verified_status = 1
WHERE election_id = 20240004 AND candidate_id = (SELECT candidate_id FROM candidate WHERE election_id = 20240004 AND full_name = 'Vo Thi Thanh Hoa');

UPDATE election_result SET total_votes = 98, verified_status = 1
WHERE election_id = 20240004 AND candidate_id = (SELECT candidate_id FROM candidate WHERE election_id = 20240004 AND full_name = 'Dang Minh Khoa');

-- ── ELECTION 20240005: University Student Union (UPCOMING)
-- No votes yet — leave as 0
INSERT INTO election_result (election_id, candidate_id, total_votes, verified_status)
SELECT 20240005, candidate_id, 0, 0
FROM candidate WHERE election_id = 20240005
ON DUPLICATE KEY UPDATE total_votes = 0;

SET FOREIGN_KEY_CHECKS = 1;

-- ── VERIFY RESULTS ──
SELECT
  e.election_name,
  c.full_name,
  c.party_affiliation,
  er.total_votes,
  ROUND(er.total_votes * 100.0 / SUM(er.total_votes) OVER (PARTITION BY er.election_id), 1) AS share_pct
FROM election_result er
JOIN candidate c ON er.candidate_id = c.candidate_id
JOIN election e  ON er.election_id  = e.election_id
ORDER BY er.election_id, er.total_votes DESC;
