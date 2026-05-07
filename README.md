# 🗳️ Online Voting System Database

**Group 5 | Topic 19 | Principles of Database Management (IT079IU)**
**Vietnam National University – HCMC, International University**
**Instructor: Assoc. Prof. Dr. Nguyễn Thị Thúy Loan**

[![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.java.com)
[![MySQL](https://img.shields.io/badge/MySQL-00758F?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com)
[![Swing](https://img.shields.io/badge/UI-Java%20Swing-blue?style=for-the-badge)](https://docs.oracle.com/javase/tutorial/uiswing/)

---

## 👥 Team Members

| Student ID | Name | Role |
|---|---|---|
| ITITWE24075 | Nguyễn Khang Vỹ | Leader |
| ITITWE24002 | Nguyễn Ngọc Quang Anh | Member |
| ITITWE24030 | Phạm Nguyễn Phúc An | Member |
| ITITWE24068 | Mai Trần Tâm | Member |
| ITITWE24015 | Nguyễn Minh Nhân | Member |
| ITITWE24044 | Nguyễn Võ Minh Huy | Member |
| ITITWE24012 | Phan Nhật Huy | Member |
| ITITWE24069 | Nguyễn Xuân Thành | Member |

---

## 📌 About The Project

The **Online Voting System Database** is a desktop-based e-voting application designed to replace traditional paper-based voting methods with a secure, efficient, and transparent digital platform. The system enables administrators to manage elections, register voters, maintain candidate information, and generate voting results — while voters can securely authenticate, browse available elections, and cast ballots following the **one voter – one vote** principle.

The database is implemented using MySQL and follows the **relational model normalized to Third Normal Form (3NF)**, ensuring data integrity, minimal redundancy, and protection against update anomalies.

---

## ✨ Key Features

- 🔐 **Voter Authentication** — National ID + password login with PENDING/ACTIVE status flow
- 📋 **Self-Registration** — New voters register themselves; accounts require admin approval
- 🗳️ **Secure Ballot Casting** — One-time token mechanism prevents double-voting atomically
- 📊 **Results Dashboard** — Any authenticated voter can query live vote tallies by election ID
- 🔑 **Password Management** — In-session password change with server-side verification
- 📜 **Audit Logging** — Every LOGIN, VOTE_CAST, TOKEN_ISSUED, LOGOUT, and PASSWORD_CHANGED event is recorded with timestamp
- 🛡️ **Security Event Tracking** — Anomalous system events (SQL injection attempts, DDoS, etc.) are logged with severity levels

---

## 🏗️ System Architecture

The application follows a strict **3-layer architecture**:

```
┌─────────────────────────────────────────┐
│        Presentation Layer               │
│   Java Swing GUI (LoginPanel,           │
│   VotingPanel, ResultsPanel, ...)        │
├─────────────────────────────────────────┤
│        Business Logic Layer             │
│   Plain Java Classes + Enums            │
│   (Voter, Election, Token, Vote, ...)   │
├─────────────────────────────────────────┤
│        Data Access Layer                │
│   JDBC + DAO Classes                    │
│   (VoterDAO, ElectionDAO, VoteDAO, ...) │
├─────────────────────────────────────────┤
│        MySQL Database                   │
│   onlinevotingsystem (9 tables)         │
└─────────────────────────────────────────┘
```

No layer skips another — the Presentation Layer only calls the Business Logic Layer, which in turn calls the Data Access Layer.

---

## 🗂️ Project Structure

```
PDM_SourceCode_Group5/
├── lib/
│   └── mysql-connector-j-9.7.0.jar
└── src/main/java/com/evoting/
    ├── dao/                        # Data Access Objects (JDBC)
    │   ├── AuditLogDAO.java
    │   ├── CandidateDAO.java
    │   ├── ElectionDAO.java
    │   ├── TokenDAO.java
    │   ├── VoteDAO.java
    │   └── VoterDAO.java
    ├── entity/                     # Domain model (POJOs)
    │   ├── BaseEntity.java
    │   ├── AuditLog.java
    │   ├── Ballot.java
    │   ├── Candidate.java
    │   ├── Election.java
    │   ├── ElectionResult.java
    │   ├── SecurityEvent.java
    │   ├── Token.java
    │   ├── Vote.java
    │   ├── Voter.java
    │   └── VoterElection.java
    ├── enums/
    │   ├── ActionType.java         # REGISTER, LOGIN, VOTE, TOKEN_ISSUED, ...
    │   ├── ElectionStatus.java     # UPCOMING, ACTIVE, CLOSED, VERIFIED
    │   ├── Severity.java           # LOW, MEDIUM, HIGH, CRITICAL
    │   └── VoterStatus.java        # PENDING, ACTIVE, SUSPENDED, DEACTIVATED
    ├── repository/
    │   ├── Repository.java
    │   └── VoterRepository.java
    ├── ui/                         # Java Swing panels
    │   ├── MainFrame.java          # CardLayout container & router
    │   ├── LoginPanel.java
    │   ├── RegisterPanel.java
    │   ├── ElectionListPanel.java
    │   ├── VotingPanel.java
    │   ├── ResultsPanel.java
    │   └── ChangePasswordPanel.java
    └── util/
        └── DatabaseConnection.java # Singleton DB connection
```

---

## 🗃️ Database Schema

The system uses the `onlinevotingsystem` MySQL database with **9 tables** normalized to 3NF:

| Table | Primary Key | Description |
|---|---|---|
| `voter` | `voter_id` | Registered citizens; tracks national_id, email, status |
| `election` | `election_id` | Electoral events with start/end dates and status lifecycle |
| `candidate` | `candidate_id` | Candidates per election with party affiliation and manifesto |
| `ballot` | `ballot_id` | Ballot type, language, and accessibility options per election |
| `token` | `token_id` | Single-use authorization credentials issued per voter per election |
| `vote` | `vote_id` | Immutable encrypted vote records referencing candidate, election, ballot, token |
| `election_result` | `result_id` | Certified aggregate vote totals per candidate |
| `audit_log` | `log_id` | Timestamped record of all voter actions |
| `security_event` | `event_id` | Anomalous/security-relevant system events with severity |
| `voter_election` | `(voter_id, election_id)` | Associative table resolving voter ↔ election many-to-many |

> All tables satisfy 1NF, 2NF, and 3NF — no partial dependencies or transitive dependencies exist.

---

## ⚙️ Setup & Installation

### Prerequisites

- Java JDK 11 or higher
- MySQL Server 8.x
- IDE: IntelliJ IDEA or NetBeans (recommended)

### Step 1 — Import the Database

```bash
mysql -u root -p < PDM_Database_Group5.sql
```

Or via MySQL Workbench: **Server → Data Import → select `PDM_Database_Group5.sql`**

### Step 2 — Configure Database Connection

Edit `src/main/resources/db.properties`:

```properties
db.url=jdbc:mysql://localhost:3306/onlinevotingsystem
db.username=root
db.password=YOUR_MYSQL_PASSWORD
```

### Step 3 — Add MySQL Driver to Classpath

Add `lib/mysql-connector-j-9.7.0.jar` to your project build path.

**In IntelliJ IDEA:**
`File → Project Structure → Modules → Dependencies → (+) → JARs or Directories`

### Step 4 — Run the Application

Run `MainFrame.java` as the main entry point. The application launches at 800×600px centered on screen.

---

## 🖥️ Application Screens

| Screen | Class | Purpose |
|---|---|---|
| Login | `LoginPanel` | Voter authentication via National ID + password |
| Register | `RegisterPanel` | New voter self-registration (creates PENDING account) |
| Elections List | `ElectionListPanel` | Browse all elections; only ACTIVE elections allow voting |
| Voting | `VotingPanel` | Candidate selection and ballot submission with token validation |
| Results | `ResultsPanel` | View vote tallies per candidate for any election by ID |
| Change Password | `ChangePasswordPanel` | In-session secure password update |

---

## 🛠️ Tools & Technologies

| Task | Tool / Software |
|---|---|
| ERD Design | Draw.io |
| Database | MySQL 8.x |
| Java Interface | Java (NetBeans / VS Code) |
| Report Writing | MS Word |
| Presentation | PowerPoint, Canva |
| Reference Citation | Zotero |
| Data Generation | Mockaroo + ChatGPT + Claude |

---

## 🔒 Security Design

- **PreparedStatements** used in all DAO classes to prevent SQL injection
- **One-time token mechanism** — token consumption and vote insertion are wrapped in a single atomic transaction; either both succeed or both roll back
- **Audit logging** on all major actions: LOGIN, VOTE_CAST, TOKEN_ISSUED, LOGOUT, PASSWORD_CHANGED
- **Client-side validation** before every DB call (email regex, min password length 6, required fields)
- **SwingWorker** offloads all DB operations off the Event Dispatch Thread, preventing UI freezes

> ⚠️ **Note:** Passwords are currently stored in plain text. BCrypt/Argon2 hashing is identified as a mandatory improvement before any production use.

---

## 📄 Report & Database Files

- 📄 [`PDM_FinalReport_Group5.pdf`](./PDM_FinalReport_Group5.pdf) — Full project report
- 🗄️ [`PDM_Database_Group5.sql`](./PDM_Database_Group5.sql) — MySQL database dump

---

## 📚 References

1. S. El Kafhali, "Blockchain-Based Electronic Voting System," *Mathematical Problems in Engineering*, 2024. https://doi.org/10.1155/2024/5591147
2. e-Estonia, "World's first mostly online national elections," 2023. https://e-estonia.com
3. ScienceDirect, "Research on online voting systems," 2022. https://www.sciencedirect.com/science/article/pii/S0740624X2200051X
4. T. Haarseim & G. Wetherall-Grujić, "Online Voting: The Essentials," *Democracy Technologies*, 2024. https://democracy-technologies.org
5. Viblo, "Học Singleton Pattern trong 5 phút," 2017. https://viblo.asia/p/hoc-singleton-pattern-trong-5-phut-4P856goOKY3

---
