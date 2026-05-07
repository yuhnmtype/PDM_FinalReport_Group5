package com.evoting.dao;

import com.evoting.util.DatabaseConnection;

import java.sql.*;
import java.util.UUID;

public class TokenDAO {

    /** Issues a new single-use token for a voter in an election. */
    public String issueToken(int electionId, int ballotId) throws SQLException {
        String sql = """
                INSERT INTO token (token_value, election_id, ballot_id, is_used, created_at)
                VALUES (?, ?, ?, FALSE, NOW())
                """;
        String tokenValue = UUID.randomUUID().toString();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tokenValue);
            ps.setInt(2, electionId);
            ps.setInt(3, ballotId);
            ps.executeUpdate();
        }
        return tokenValue;
    }

    /**
     * Consumes a token atomically — marks it used only if it was unused.
     * Returns true if the token was valid and successfully consumed.
     */
    public boolean consumeToken(String tokenValue) throws SQLException {
        String sql = """
                UPDATE token SET is_used = TRUE, used_at = NOW()
                WHERE token_value = ? AND is_used = FALSE
                """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tokenValue);
            // executeUpdate returns 0 if token was already used or not found
            return ps.executeUpdate() > 0;
        }
    }

    public boolean isTokenValid(String tokenValue) throws SQLException {
        String sql = "SELECT is_used FROM token WHERE token_value = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tokenValue);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return !rs.getBoolean("is_used");
                }
            }
        }
        return false;
    }

    // FIX #2 — method mới: VotingPanel cần token_id để lưu vào bảng vote
    public int findTokenIdByValue(String tokenValue) throws SQLException {
        String sql = "SELECT token_id FROM token WHERE token_value = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tokenValue);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("token_id");
            }
        }
        return -1; // không tìm thấy
    }
}