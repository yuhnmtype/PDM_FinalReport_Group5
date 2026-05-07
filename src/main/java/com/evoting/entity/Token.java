package com.evoting.entity;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Represents a single-use voting token.
 * Pure Java POJO — no JPA/Jakarta annotations.
 */
public class Token {

    private int tokenId;
    private String tokenValue;
    private int electionId;
    private int ballotId;
    private boolean isUsed = false;
    private LocalDateTime usedAt;

    public Token() {
        this.tokenValue = UUID.randomUUID().toString();
    }

    /** Consumes the token — returns false if already used. */
    public boolean consume() {
        if (isUsed) return false;
        this.isUsed = true;
        this.usedAt = LocalDateTime.now();
        return true;
    }

    // Getters and Setters

    public int getTokenId() { return tokenId; }
    public void setTokenId(int tokenId) { this.tokenId = tokenId; }

    public String getTokenValue() { return tokenValue; }
    public void setTokenValue(String tokenValue) { this.tokenValue = tokenValue; }

    public int getElectionId() { return electionId; }
    public void setElectionId(int electionId) { this.electionId = electionId; }

    public int getBallotId() { return ballotId; }
    public void setBallotId(int ballotId) { this.ballotId = ballotId; }

    public boolean isUsed() { return isUsed; }
    public void setUsed(boolean used) { isUsed = used; }

    public LocalDateTime getUsedAt() { return usedAt; }
    public void setUsedAt(LocalDateTime usedAt) { this.usedAt = usedAt; }
}