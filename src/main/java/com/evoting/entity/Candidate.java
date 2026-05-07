package com.evoting.entity;

/**
 * Represents a candidate in an election.
 * Pure Java POJO — no JPA/Jakarta annotations.
 * electionId stored as plain int (no lazy-loaded object reference).
 */
public class Candidate extends BaseEntity {

    private int candidateId;
    private int electionId;
    private String fullName;
    private String partyAffiliation;
    private String manifesto;

    public String getParty() { return partyAffiliation; }

    // Getters and Setters

    public int getCandidateId() { return candidateId; }
    public void setCandidateId(int candidateId) { this.candidateId = candidateId; }

    public int getElectionId() { return electionId; }
    public void setElectionId(int electionId) { this.electionId = electionId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPartyAffiliation() { return partyAffiliation; }
    public void setPartyAffiliation(String partyAffiliation) { this.partyAffiliation = partyAffiliation; }

    public String getManifesto() { return manifesto; }
    public void setManifesto(String manifesto) { this.manifesto = manifesto; }
}