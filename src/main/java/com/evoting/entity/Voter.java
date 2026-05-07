package com.evoting.entity;

import com.evoting.enums.VoterStatus;

/**
 * Represents a registered voter.
 * Pure Java POJO — no JPA/Jakarta annotations.
 */
public class Voter extends BaseEntity {

    private int voterId;
    private String nationalId;
    private String fullName;
    private String email;
    private String password;
    private String phoneNumber;
    private VoterStatus status;

    public void register() {
        this.status = VoterStatus.ACTIVE;
    }

    // Getters and Setters

    public int getVoterId() { return voterId; }
    public void setVoterId(int voterId) { this.voterId = voterId; }

    public String getNationalId() { return nationalId; }
    public void setNationalId(String nationalId) { this.nationalId = nationalId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public VoterStatus getStatus() { return status; }
    public void setStatus(VoterStatus status) { this.status = status; }
}