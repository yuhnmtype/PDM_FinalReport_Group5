package com.evoting.dao;

import com.evoting.util.DatabaseConnection;

import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

public class VoteDAO {

    /**
     * Inserts a new Vote record.
     * encryptedVote should be the encrypted/hashed candidate choice — never plaintext.
     */
    public boolean castVote(int candidateId, int electionId,
                            int ballotId, int tokenId,
                            String encryptedVote) throws SQLException {
        String sql = """
                INSERT INTO vote (candidate_id, election_id, ballot_id, token_id, encrypted_vote, voted_at)
                VALUES (?, ?, ?, ?, ?, NOW())
                """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, candidateId);
            ps.setInt(2, electionId);
            ps.setInt(3, ballotId);
            ps.setInt(4, tokenId);
            ps.setString(5, encryptedVote);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Returns vote counts per candidate for a given election.
     * Map key = candidateId, value = totalVotes.
     */
    public Map<Integer, Integer> countVotesByElection(int electionId) throws SQLException {
        String sql = """
                SELECT candidate_id, COUNT(*) AS total_votes
                FROM vote
                WHERE election_id = ?
                GROUP BY candidate_id
                ORDER BY total_votes DESC
                """;
        Map<Integer, Integer> results = new LinkedHashMap<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, electionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    results.put(
                        rs.getInt("candidate_id"),
                        rs.getInt("total_votes")
                    );
                }
            }
        }
        return results;
    }

    public int totalVotesForElection(int electionId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM vote WHERE election_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, electionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }
}
