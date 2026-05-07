package com.evoting.entity;

import java.time.LocalDateTime;

/**
 * Base class for all entities.
 * Pure Java — no JPA/Jakarta annotations.
 * createdAt and updatedAt are set manually in the DAO layer (via NOW() in SQL).
 */
public abstract class BaseEntity {

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}