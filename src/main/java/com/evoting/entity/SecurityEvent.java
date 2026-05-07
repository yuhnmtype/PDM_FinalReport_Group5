package com.evoting.entity;

import com.evoting.enums.Severity;

import java.time.LocalDateTime;

/**
 * Represents a security event log entry.
 * Pure Java POJO — no JPA/Jakarta annotations.
 */
public class SecurityEvent {

    private int eventId;
    private String eventType;
    private Severity severity;
    private String description;
    private LocalDateTime timestamp;
    private String ipAddress;
    private int voterId;

    public Severity getSeverity() { return severity; }

    public boolean isHighSeverity() {
        return severity == Severity.HIGH || severity == Severity.CRITICAL;
    }

    // Getters and Setters

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public String getEventType() { return eventType; }
    public void setEventType(String eventType) { this.eventType = eventType; }

    public void setSeverity(Severity severity) { this.severity = severity; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public int getVoterId() { return voterId; }
    public void setVoterId(int voterId) { this.voterId = voterId; }
}