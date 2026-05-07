package com.evoting.entity;

import java.time.LocalDateTime;

/**
 * Represents a cast vote.
 * Pure Java POJO — no JPA/Jakarta annotations.
 * Foreign keys stored as plain int fields instead of object references.
 */
public class Vote {

    private int voteId;
    private int candidateId;
    private int electionId;
    private int ballotId;
    private int tokenId;
    private String encryptedVote;
    private LocalDateTime votedAt;

    public LocalDateTime getVoteTimestamp() { return votedAt; }

    // Getters and Setters

    public int getVoteId() { return voteId; }
    public void setVoteId(int voteId) { this.voteId = voteId; }

    public int getCandidateId() { return candidateId; }
    public void setCandidateId(int candidateId) { this.candidateId = candidateId; }

    public int getElectionId() { return electionId; }
    public void setElectionId(int electionId) { this.electionId = electionId; }

    public int getBallotId() { return ballotId; }
    public void setBallotId(int ballotId) { this.ballotId = ballotId; }

    public int getTokenId() { return tokenId; }
    public void setTokenId(int tokenId) { this.tokenId = tokenId; }

    public String getEncryptedVote() { return encryptedVote; }
    public void setEncryptedVote(String encryptedVote) { this.encryptedVote = encryptedVote; }

    public LocalDateTime getVotedAt() { return votedAt; }
    public void setVotedAt(LocalDateTime votedAt) { this.votedAt = votedAt; }
}