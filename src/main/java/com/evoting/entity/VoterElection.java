package com.evoting.entity;

import java.time.LocalDateTime;

/**
 * Junction entity linking Voter and Election (many-to-many).
 * Pure Java POJO — no JPA/Jakarta annotations.
 * Composite PK (voter_id, election_id) enforced at the DB level.
 */
public class VoterElection {

    private int voterId;
    private int electionId;
    private LocalDateTime registeredAt;
    private String eligibilityStatus;
    private boolean hasVoted = false;

    public void markAsVoted() {
        this.hasVoted = true;
    }

    // Getters and Setters

    public int getVoterId() { return voterId; }
    public void setVoterId(int voterId) { this.voterId = voterId; }

    public int getElectionId() { return electionId; }
    public void setElectionId(int electionId) { this.electionId = electionId; }

    public LocalDateTime getRegisteredAt() { return registeredAt; }
    public void setRegisteredAt(LocalDateTime registeredAt) { this.registeredAt = registeredAt; }

    public String getEligibilityStatus() { return eligibilityStatus; }
    public void setEligibilityStatus(String eligibilityStatus) { this.eligibilityStatus = eligibilityStatus; }

    public boolean isHasVoted() { return hasVoted; }
    public void setHasVoted(boolean hasVoted) { this.hasVoted = hasVoted; }
}