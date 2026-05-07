package com.evoting.entity;

import java.util.Arrays;
import java.util.List;

/**
 * Represents a ballot for an election.
 * Pure Java POJO — no JPA/Jakarta annotations.
 * Converted from abstract class to concrete class since JPA inheritance
 * is not used. accessibility_option stored as a plain String field.
 */
public class Ballot extends BaseEntity {

    private int ballotId;
    private int electionId;
    private String ballotType;
    private String language;
    private String accessibilityOption;

    /** Returns a simple text render of the ballot type and language. */
    public String render() {
        return ballotType + " | " + language;
    }

    /** Returns accessibility options split by comma if multiple stored. */
    public List<String> getAccessibilityOptions() {
        if (accessibilityOption == null || accessibilityOption.isBlank()) {
            return List.of();
        }
        return Arrays.asList(accessibilityOption.split(","));
    }

    // Getters and Setters

    public int getBallotId() { return ballotId; }
    public void setBallotId(int ballotId) { this.ballotId = ballotId; }

    public int getElectionId() { return electionId; }
    public void setElectionId(int electionId) { this.electionId = electionId; }

    public String getBallotType() { return ballotType; }
    public void setBallotType(String ballotType) { this.ballotType = ballotType; }

    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }

    public String getAccessibilityOption() { return accessibilityOption; }
    public void setAccessibilityOption(String accessibilityOption) {
        this.accessibilityOption = accessibilityOption;
    }
}