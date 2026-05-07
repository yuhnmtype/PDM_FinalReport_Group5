package com.evoting.dao;

import com.evoting.entity.Election;
import com.evoting.enums.ElectionStatus;
import com.evoting.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ElectionDAO {

    public boolean insert(Election election) throws SQLException {
        String sql = """
                INSERT INTO election (election_name, start_date, end_date, status, created_at, updated_at)
                VALUES (?, ?, ?, ?, NOW(), NOW())
                """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, election.getElectionName());
            ps.setDate(2, Date.valueOf(election.getStartDate()));
            ps.setDate(3, Date.valueOf(election.getEndDate()));
            ps.setString(4, election.getStatus().name());

            int rows = ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) election.setElectionId(keys.getInt(1));
            }
            return rows > 0;
        }
    }

    public Optional<Election> findById(int electionId) throws SQLException {
        String sql = "SELECT * FROM election WHERE election_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, electionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        }
        return Optional.empty();
    }

    public List<Election> findAll() throws SQLException {
        String sql = "SELECT * FROM election ORDER BY start_date DESC";
        List<Election> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public List<Election> findByStatus(ElectionStatus status) throws SQLException {
        String sql = "SELECT * FROM election WHERE status = ? ORDER BY start_date DESC";
        List<Election> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status.name());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public boolean updateStatus(int electionId, ElectionStatus status) throws SQLException {
        String sql = "UPDATE election SET status = ?, updated_at = NOW() WHERE election_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status.name());
            ps.setInt(2, electionId);
            return ps.executeUpdate() > 0;
        }
    }

    // FIX #3 — method mới: VotingPanel cần ballotId thực từ DB, không hardcode
    public int findBallotIdByElection(int electionId) throws SQLException {
        String sql = "SELECT ballot_id FROM ballot WHERE election_id = ? LIMIT 1";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, electionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("ballot_id");
            }
        }
        return -1; // không tìm thấy ballot cho election này
    }

    private Election mapRow(ResultSet rs) throws SQLException {
        Election e = new Election();
        e.setElectionId(rs.getInt("election_id"));
        e.setElectionName(rs.getString("election_name"));
        e.setStartDate(rs.getDate("start_date").toLocalDate());
        e.setEndDate(rs.getDate("end_date").toLocalDate());
        e.setStatus(ElectionStatus.valueOf(rs.getString("status")));
        return e;
    }
}