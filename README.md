# 🗳️ E-Voting System — PDM Final Project

**Group 5 | Principles of Database Management | Ho Chi Minh City**

[![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)](https://www.java.com)
[![MySQL](https://img.shields.io/badge/MySQL-00758F?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

---

## 📌 About The Project

A secure, desktop-based **Online Voting System** built with Java Swing and MySQL. The system supports full voter lifecycle management — from registration and OTP-based authentication to casting votes and viewing election results — with complete audit logging for transparency and accountability.

---

## ✨ Features

- 🔐 **Secure Authentication** — OTP-based login with session management
- 🗳️ **Voting Panel** — Single-choice ballot system with token validation
- 📊 **Results Dashboard** — Real-time election result viewing
- 👤 **Voter Management** — Registration, status tracking, password change
- 📋 **Audit Logging** — Full action history (login, vote cast, logout)
- 🌐 **Accessibility Support** — Screen reader, large print, audio description options

---

## 🗂️ Project Structure

```
PDM_FinalReport_Group5/
├── PDM_FinalReport_Group5.pdf       # Final report
├── PDM_Database_Group5.sql          # MySQL database dump
└── PDM_SourceCode_Group5/
    ├── lib/
    │   └── mysql-connector-j-9.7.0.jar
    └── src/main/java/com/evoting/
        ├── dao/                     # Data Access Objects
        │   ├── AuditLogDAO.java
        │   ├── CandidateDAO.java
        │   ├── ElectionDAO.java
        │   ├── TokenDAO.java
        │   ├── VoteDAO.java
        │   └── VoterDAO.java
        ├── entity/                  # Domain models
        │   ├── AuditLog.java
        │   ├── Ballot.java
        │   ├── Candidate.java
        │   ├── Election.java
        │   ├── ElectionResult.java
        │   ├── Token.java
        │   ├── Vote.java
        │   └── Voter.java
        ├── enums/
        │   ├── ActionType.java
        │   ├── ElectionStatus.java
        │   └── VoterStatus.java
        ├── repository/
        │   ├── Repository.java
        │   └── VoterRepository.java
        ├── ui/                      # Java Swing UI
        │   ├── LoginPanel.java
        │   ├── RegisterPanel.java
        │   ├── MainFrame.java
        │   ├── VotingPanel.java
        │   ├── ElectionListPanel.java
        │   ├── ResultsPanel.java
        │   └── ChangePasswordPanel.java
        └── util/
            └── DatabaseConnection.java
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Language | Java (JDK 11+) |
| UI Framework | Java Swing |
| Database | MySQL 8.x |
| DB Driver | MySQL Connector/J 9.7.0 |
| IDE (recommended) | IntelliJ IDEA / VS Code |

---

## ⚙️ Setup & Installation

### Prerequisites
- Java JDK 11 or higher
- MySQL Server 8.x
- Any Java IDE (IntelliJ IDEA recommended)

### Step 1 — Import the Database

```sql
-- In MySQL Workbench or CLI:
mysql -u root -p < PDM_Database_Group5.sql
```

Or open MySQL Workbench → Server → Data Import → select `PDM_Database_Group5.sql`

### Step 2 — Configure Database Connection

Edit `src/main/resources/db.properties`:

```properties
db.url=jdbc:mysql://localhost:3306/onlinevotingsystem
db.username=root
db.password=your_password_here
```

### Step 3 — Add the MySQL Driver

Make sure `lib/mysql-connector-j-9.7.0.jar` is added to your project's build path / classpath.

**In IntelliJ IDEA:**
`File → Project Structure → Modules → Dependencies → + → JARs or Directories`

### Step 4 — Run the App

Run `MainFrame.java` as the entry point.

---

## 🗃️ Database Schema

The system uses the `onlinevotingsystem` database with the following core tables:

| Table | Description |
|---|---|
| `voter` | Registered voters and their status |
| `election` | Election metadata and status |
| `candidate` | Candidates per election |
| `vote` | Recorded votes (anonymized) |
| `ballot` | Ballot type and accessibility config |
| `token` | One-time voting tokens |
| `audit_log` | Full activity trail |

---

## 👥 Team — Group 5

| Name | Role |
|---|---|
| _(add member names)_ | _(add roles)_ |

---

## 📄 License

This project is submitted as academic coursework for the **Principles of Database Management** course.

---

