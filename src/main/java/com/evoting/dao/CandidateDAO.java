package com.evoting.dao;

import com.evoting.entity.Candidate;
import com.evoting.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CandidateDAO {

    public boolean insert(Candidate candidate) throws SQLException {
        String sql = """
                INSERT INTO candidate (election_id, full_name, party_affiliation, manifesto, created_at, updated_at)
                VALUES (?, ?, ?, ?, NOW(), NOW())
                """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // FIX #1 — dùng getElectionId() thay vì getElection().getElectionId() (JPA đã bỏ)
            ps.setInt(1, candidate.getElectionId());
            ps.setString(2, candidate.getFullName());
            ps.setString(3, candidate.getPartyAffiliation());
            ps.setString(4, candidate.getManifesto());

            int rows = ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) candidate.setCandidateId(keys.getInt(1));
            }
            return rows > 0;
        }
    }

    public List<Candidate> findByElection(int electionId) throws SQLException {
        String sql = "SELECT * FROM candidate WHERE election_id = ? ORDER BY full_name";
        List<Candidate> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, electionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public Optional<Candidate> findById(int candidateId) throws SQLException {
        String sql = "SELECT * FROM candidate WHERE candidate_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, candidateId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        }
        return Optional.empty();
    }

    private Candidate mapRow(ResultSet rs) throws SQLException {
        Candidate c = new Candidate();
        c.setCandidateId(rs.getInt("candidate_id"));
        c.setElectionId(rs.getInt("election_id")); // FIX #5 — thiếu map election_id
        c.setFullName(rs.getString("full_name"));
        c.setPartyAffiliation(rs.getString("party_affiliation"));
        c.setManifesto(rs.getString("manifesto"));
        return c;
    }
}