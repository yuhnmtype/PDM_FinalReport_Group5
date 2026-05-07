package com.evoting.entity;

/**
 * Represents a certified election result record.
 * Pure Java POJO — no JPA/Jakarta annotations.
 */
public class ElectionResult {

    private int resultId;
    private int electionId;
    private int candidateId;
    private int totalVotes;
    private boolean verifiedStatus = false;

    // Getters and Setters

    public int getResultId() { return resultId; }
    public void setResultId(int resultId) { this.resultId = resultId; }

    public int getElectionId() { return electionId; }
    public void setElectionId(int electionId) { this.electionId = electionId; }

    public int getCandidateId() { return candidateId; }
    public void setCandidateId(int candidateId) { this.candidateId = candidateId; }

    public int getTotalVotes() { return totalVotes; }
    public void setTotalVotes(int totalVotes) { this.totalVotes = totalVotes; }

    public boolean isVerifiedStatus() { return verifiedStatus; }
    public void setVerifiedStatus(boolean verifiedStatus) { this.verifiedStatus = verifiedStatus; }
}