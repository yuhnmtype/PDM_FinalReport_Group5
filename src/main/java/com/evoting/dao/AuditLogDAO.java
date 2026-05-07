package com.evoting.dao;

import com.evoting.enums.ActionType;
import com.evoting.util.DatabaseConnection;

import java.sql.*;

public class AuditLogDAO {

    /** Logs every voter action. Called after every significant operation. */
    public void log(int voterId, ActionType actionType, String details) {
        String sql = """
                INSERT INTO audit_log (voter_id, action_type, timestamp, details)
                VALUES (?, ?, NOW(), ?)
                """;
        // Logging must never crash the main operation — swallow exceptions here
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, voterId);
            ps.setString(2, actionType.name());
            ps.setString(3, details);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("AuditLog insert failed: " + e.getMessage());
        }
    }
}
