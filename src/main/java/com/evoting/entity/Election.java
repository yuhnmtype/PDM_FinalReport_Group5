package com.evoting.entity;

import com.evoting.enums.ElectionStatus;

import java.time.LocalDate;

/**
 * Represents an election.
 * Pure Java POJO — no JPA/Jakarta annotations.
 */
public class Election extends BaseEntity {

    private int electionId;
    private String electionName;
    private LocalDate startDate;
    private LocalDate endDate;
    private ElectionStatus status;

    public boolean isActive() {
        LocalDate today = LocalDate.now();
        return status == ElectionStatus.ACTIVE
                && !today.isBefore(startDate)
                && !today.isAfter(endDate);
    }

    // Getters and Setters

    public int getElectionId() { return electionId; }
    public void setElectionId(int electionId) { this.electionId = electionId; }

    public String getElectionName() { return electionName; }
    public void setElectionName(String electionName) { this.electionName = electionName; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public ElectionStatus getStatus() { return status; }
    public void setStatus(ElectionStatus status) { this.status = status; }
}