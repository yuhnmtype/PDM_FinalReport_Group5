# VoteSecure — Online Voting System

**Course:** Principles of Database Management (IT079IU)  
**Institution:** International University, Vietnam National University Ho Chi Minh City  
**Instructor:** Assoc. Prof. Dr. Nguyen Thi Thuy Loan  
**Topic:** 19 — Online Voting System Database  

---

## Team Members

| Student ID | Name | Role |
|---|---|---|
| ITITWE24075 | Nguyen Khang Vy | Leader |
| ITITWE24002 | Nguyen Ngoc Quang Anh | Member |
| ITITWE24030 | Pham Nguyen Phuc An | Member |
| ITITWE24068 | Mai Tran Tam | Member |
| ITITWE24015 | Nguyen Minh Nhan | Member |
| ITITWE24044 | Nguyen Vo Minh Huy | Member |
| ITITWE24012 | Phan Nhat Huy | Member |
| ITITWE24069 | Nguyen Xuan Thanh | Member |

---

## Project Overview

VoteSecure is a web-based election management platform developed as a final project for the Principles of Database Management course. The system allows registered voters to log in, view available elections, and cast votes in real time. Administrators can manage voter accounts, monitor audit logs, and review security events through a dedicated dashboard.

The database backend is implemented in MySQL and consists of eight tables normalized to Third Normal Form (3NF). A token-based voting mechanism ensures each voter can cast exactly one vote per election. Vote records are stored with SHA-256 encrypted payloads and all significant actions are recorded in an audit log. The application layer is built with Node.js and Express.js, exposing a RESTful API to a multi-page frontend built with HTML, CSS, and JavaScript.

---

## Technology Stack

| Category | Tool / Technology |
|---|---|
| Database | MySQL 8.0 |
| Backend Runtime | Node.js v20 |
| Web Framework | Express.js 4 |
| DB Connector | mysql2/promise |
| Config | dotenv |
| Frontend | HTML5, CSS3, Vanilla JavaScript |
| Design Tool | ERDPlus.com |
| Version Control | GitHub, VS Code Live Share |

---

## Database Schema

The database consists of eight tables and one view, all normalized to 3NF.

| Table | Primary Key | Description |
|---|---|---|
| voter | voter_id | Registered users with role (VOTER/ADMIN) and status (PENDING/ACTIVE/SUSPENDED) |
| election | election_id | Election events with status (UPCOMING/ACTIVE/CLOSED/VERIFIED) |
| candidate | candidate_id | Candidates linked to a specific election, with party and manifesto |
| token | token_id | One-time voting tokens issued per voter per election |
| vote | vote_id | Encrypted vote records linked to a token and candidate |
| voter_election | (voter_id, election_id) | Junction table tracking voter registration and eligibility per election |
| audit_log | log_id | Records all significant user actions with timestamps |
| security_event | event_id | Records security incidents such as failed logins and suspicious activity |
**View:** `v_election_result` — calculates total votes per candidate per election dynamically from the vote table, replacing a stored aggregate table to satisfy 3NF.

### Key Design Decisions

- `token` enforces a UNIQUE constraint on `(voter_id, election_id)`, preventing duplicate token generation.
- `vote` references only `token_id` and `candidate_id`. Election context is derived through the token relationship, removing transitive dependencies.
- `v_election_result` is a view rather than a table, eliminating stored derived data and update anomalies.
- `voter_election` stores only `eligibility_status` and `registered_at`. The `has_voted` flag was removed because the same information is available through `token.is_used`.

---

## Project Structure

```
evoting-backend/
├── server.js               Entry point: Express app, middleware, route mounting
├── .env                    Environment variables (DB credentials, port)
├── config/
│   └── db.js               MySQL connection pool using mysql2/promise
├── controllers/
│   ├── authController.js   login(), register(), changePassword()
│   └── voteController.js   castVote() with transaction management
├── routes/
│   ├── auth.js             POST /api/login, /api/register, /api/change-password
│   ├── elections.js        GET /api/elections, /api/elections/:id/candidates, /api/elections/:id/results
│   ├── votes.js            POST /api/vote
│   └── admin.js            GET/POST /api/voters, /api/audit-log, /api/security-events, /api/stats
└── public/
    ├── index.html          Login page
    ├── css/style.css       Global stylesheet
    ├── js/app.js           Shared JavaScript utilities
    └── pages/
        ├── register.html
        ├── elections.html
        ├── voting.html
        ├── results.html
        ├── admin.html
        └── change-password.html
```

---

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| POST | /api/login | Authenticate voter using national_id and password |
| POST | /api/register | Register new voter (status defaults to PENDING) |
| POST | /api/change-password | Update password and log action to audit_log |
| GET | /api/elections | Return all elections ordered by election_id DESC |
| GET | /api/elections/:id/candidates | Return candidates for a specific election |
| GET | /api/elections/:id/results | Return live vote counts via v_election_result |
| POST | /api/vote | Cast vote within a database transaction |
| GET | /api/stats | Return total voters, elections, votes, active elections |
| GET | /api/voters | Return all voter records for admin management |
| POST | /api/update-voter-status | Update voter status (ACTIVE / SUSPENDED / PENDING) |
| GET | /api/audit-log | Return audit log with voter names joined |
| GET | /api/security-events | Return security event records with voter names joined |

---

## Frontend Pages

| Page | File | Purpose |
|---|---|---|
| Login | index.html | National ID and password authentication |
| Register | register.html | New voter registration (account pending admin approval) |
| Elections | elections.html | View all elections, select to vote or view results |
| Voting | voting.html | Select candidate and submit ballot |
| Results | results.html | View vote counts and winner for selected election |
| Admin Dashboard | admin.html | Manage voters, view audit log and security events |
| Change Password | change-password.html | Update account password |

---

## Setup and Installation

### Prerequisites

- Node.js v20 or higher
- MySQL 8.0
- npm

### Steps

**1. Clone the repository**
```bash
git clone https://github.com/yuhnmtype/PDM_FinalReport_Group5.git
cd PDM_FinalReport_Group5
```

**2. Install dependencies**
```bash
cd evoting-backend
npm install
```

**3. Configure environment variables**

Create a `.env` file in the `evoting-backend/` directory:
```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=onlinevoting
PORT=3000
```

**4. Set up the database**

Open MySQL Workbench and run the following files in order:
```
1. database.sql        -- Creates all 8 tables, view, and seed data
2. patch_role.sql      -- Sets admin role for the admin account
3. patch_results.sql   -- Verifies election results via the view
```

**5. Start the server**
```bash
node server.js
```

The server will start at `http://localhost:3000`.

---

## Demo Credentials

| National ID | Password | Role |
|---|---|---|
| NID-2001-AA001 | 123456 | Admin |
| NID-1998-BB002 | 123456 | Voter |
| NID-2002-GG007 | 123456 | Voter |

---

## Seed Data Summary

| Entity | Count |
|---|---|
| Voters | 46 (including 1 admin) |
| Elections | 5 |
| Candidates | 15 (3 per election) |
| Voting Tokens | 21 (13 used) |
| Votes | 13 |
| Audit Log Entries | 17 |
| Security Events | 9 |

---

## Normalization

All tables were verified against 1NF, 2NF, and 3NF requirements.

**1NF:** All attributes contain atomic, single-valued data. No repeating groups.

**2NF:** In composite-key tables such as voter_election, all non-key attributes depend on the full composite key (voter_id, election_id), not a partial subset.

**3NF:** No transitive dependencies. For example, party_affiliation in candidate depends only on candidate_id. Derived values such as total votes are not stored in base tables but calculated through the v_election_result view.

---

## Repository Contents

| File | Description |
|---|---|
| PDM_Database_Group5.sql | Full database schema and seed data |
| README.md | This file |

---

## Course Information

Vietnam National University Ho Chi Minh City — International University  
IT079IU — Principles of Database Management  
Academic Year 2024–2025