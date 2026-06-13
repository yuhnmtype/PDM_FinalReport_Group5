-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: onlinevoting
-- ------------------------------------------------------
-- Server version	8.4.8

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `voter_id` int DEFAULT NULL,
  `action_type` varchar(50) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `details` text,
  PRIMARY KEY (`log_id`),
  KEY `idx_audit_voter` (`voter_id`),
  CONSTRAINT `fk_audit_voter` FOREIGN KEY (`voter_id`) REFERENCES `voter` (`voter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=80930417 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
INSERT INTO `audit_log` VALUES (80001111,12847653,'LOGIN','2024-05-01 09:15:00','Voter authenticated via OTP from IP 103.21.44.12'),(80002222,12847653,'TOKEN_ISSUED','2024-05-01 09:20:00','One-time token generated for election 20240001'),(80003333,12847653,'VOTE_CAST','2024-05-01 09:23:47','Vote recorded for candidate 30014827 in election 20240001'),(80004444,12847653,'LOGOUT','2024-05-01 09:25:10','Session terminated normally'),(80005555,47291038,'LOGIN','2024-06-10 11:00:00','Voter authenticated via OTP from IP 118.69.72.55'),(80006661,61038274,'LOGIN','2024-07-10 08:30:00','Voter authenticated via OTP from IP 113.190.22.14'),(80007772,61038274,'TOKEN_ISSUED','2024-07-10 08:40:00','One-time token generated for election 20240003'),(80008883,61038274,'VOTE_CAST','2024-07-10 08:45:22','Vote recorded for candidate 30041528 in election 20240003'),(80009994,61038274,'LOGOUT','2024-07-10 08:47:00','Session terminated normally'),(80010005,72845019,'LOGIN','2024-07-10 10:00:00','Voter authenticated via OTP from IP 118.71.55.30'),(80011116,72845019,'TOKEN_ISSUED','2024-07-10 10:08:00','One-time token generated for election 20240003'),(80012227,72845019,'VOTE_CAST','2024-07-10 10:12:05','Vote recorded for candidate 30056274 in election 20240003'),(80013338,72845019,'LOGOUT','2024-07-10 10:14:30','Session terminated normally'),(80014449,38291647,'LOGIN','2024-07-10 13:20:00','Voter authenticated via OTP from IP 222.252.14.60'),(80015550,38291647,'TOKEN_ISSUED','2024-07-10 13:30:00','One-time token generated for election 20240003'),(80016661,38291647,'VOTE_CAST','2024-07-10 13:37:58','Vote recorded for candidate 30067391 in election 20240003'),(80017772,38291647,'LOGOUT','2024-07-10 13:40:00','Session terminated normally');
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate`
--

DROP TABLE IF EXISTS `candidate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate` (
  `candidate_id` int NOT NULL AUTO_INCREMENT,
  `election_id` int NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `party_affiliation` varchar(100) DEFAULT NULL,
  `manifesto` text,
  PRIMARY KEY (`candidate_id`),
  KEY `idx_cand_election` (`election_id`),
  CONSTRAINT `fk_cand_election` FOREIGN KEY (`election_id`) REFERENCES `election` (`election_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30169302 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate`
--

LOCK TABLES `candidate` WRITE;
/*!40000 ALTER TABLE `candidate` DISABLE KEYS */;
INSERT INTO `candidate` VALUES (30014827,20240001,'Vo Thi Thu','People Democratic Party','Strengthen rural infrastructure and healthcare access for all citizens.'),(30029163,20240002,'Nguyen Duc Long','Progressive Alliance','Invest in renewable energy and modernise provincial transport networks.'),(30041528,20240003,'Cao Thi Phuong','National Unity Front','Expand public education funding and build new community learning centres.'),(30056274,20240003,'Dinh Van Hung','People Democratic Party','Boost local economy through small business grants and farmer subsidies.'),(30067391,20240003,'Le Minh Quan','Progressive Alliance','Modernise district healthcare with digital records and telemedicine access.'),(30078412,20240001,'Nguyen Minh Duc','National Unity Front','Develop smart city infrastructure and reduce administrative red tape.'),(30089523,20240001,'Pham Thi Lan Anh','Democratic Progress Party','Promote gender equality in public office and maternal healthcare reform.'),(30091634,20240002,'Tran Quoc Huy','National Unity Front','Strengthen border trade and support export-oriented small enterprises.'),(30102745,20240002,'Le Thi Phuong Linh','Democratic Progress Party','Reform the education curriculum to include digital literacy from primary school.'),(30113856,20240004,'Bui Van Trung','People Democratic Party','Upgrade ward-level public services and digitise citizen record management.'),(30124967,20240004,'Vo Thi Thanh Hoa','Progressive Alliance','Establish community health stations in every ward for preventive care.'),(30136078,20240004,'Dang Minh Khoa','National Unity Front','Build green spaces and improve waste management in residential areas.'),(30147189,20240005,'Nguyen Thi Bich Ngoc','Student Forward Party','Expand scholarship programs and reduce tuition for low-income students.'),(30158290,20240005,'Tran Van Duc Anh','Youth Development Alliance','Build more student dormitories and upgrade campus digital infrastructure.'),(30169301,20240005,'Le Minh Tuan','Academic Excellence Union','Reform grading systems and introduce more project-based learning.');
/*!40000 ALTER TABLE `candidate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `election`
--

DROP TABLE IF EXISTS `election`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `election` (
  `election_id` int NOT NULL AUTO_INCREMENT,
  `election_name` varchar(100) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('UPCOMING','ACTIVE','CLOSED','VERIFIED') NOT NULL,
  PRIMARY KEY (`election_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20240006 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `election`
--

LOCK TABLES `election` WRITE;
/*!40000 ALTER TABLE `election` DISABLE KEYS */;
INSERT INTO `election` VALUES (20240001,'National Assembly Election 2024','2024-05-01','2024-05-01','VERIFIED'),(20240002,'Provincial Council Election 2024','2024-06-15','2024-06-15','ACTIVE'),(20240003,'District People Committee Election 2024','2024-07-10','2024-07-10','CLOSED'),(20240004,'Ward-Level Representative Election 2024','2024-08-01','2024-08-30','CLOSED'),(20240005,'University Student Union Election 2024','2024-10-01','2024-10-31','UPCOMING');
/*!40000 ALTER TABLE `election` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `security_event`
--

DROP TABLE IF EXISTS `security_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `security_event` (
  `event_id` int NOT NULL AUTO_INCREMENT,
  `event_type` varchar(50) DEFAULT NULL,
  `severity` enum('LOW','MEDIUM','HIGH','CRITICAL') NOT NULL,
  `description` text,
  `timestamp` datetime DEFAULT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `voter_id` int DEFAULT NULL,
  PRIMARY KEY (`event_id`),
  KEY `idx_sec_voter` (`voter_id`),
  CONSTRAINT `fk_sec_voter` FOREIGN KEY (`voter_id`) REFERENCES `voter` (`voter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=90010011 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `security_event`
--

LOCK TABLES `security_event` WRITE;
/*!40000 ALTER TABLE `security_event` DISABLE KEYS */;
INSERT INTO `security_event` VALUES (90001001,'UNAUTHORISED_ACCESS_ATTEMPT','HIGH','Suspended voter 83650214 attempted to log in during election 20240001.','2024-05-01 08:47:33','27.72.98.41',83650214),(90002002,'BRUTE_FORCE_DETECTED','CRITICAL','Multiple rapid login attempts detected against voter account from foreign IP.','2024-05-01 09:10:55','185.220.101.73',12847653),(90003003,'UNAUTHORISED_ACCESS_ATTEMPT','HIGH','Suspended voter 15728046 attempted to authenticate during election 20240003.','2024-07-10 09:05:14','14.177.243.85',15728046),(90004004,'POLICY_VIOLATION','MEDIUM','Pending voter 86304192 attempted to access ballot before eligibility confirmed.','2024-07-10 11:22:47','103.97.125.60',86304192),(90005005,'SQL_INJECTION_ATTEMPT','CRITICAL','Malformed national_id input detected during login attempt.','2024-05-15 14:33:21','185.100.221.45',NULL),(90006006,'BRUTE_FORCE_DETECTED','HIGH','10 failed login attempts in 60 seconds from same IP.','2024-06-20 22:10:05','91.108.4.177',NULL),(90007007,'UNAUTHORISED_ACCESS_ATTEMPT','HIGH','Suspended voter 22394018 attempted to access ballot panel.','2024-07-15 09:45:00','14.160.30.44',22394018),(90009009,'SESSION_HIJACK_ATTEMPT','CRITICAL','Suspicious token reuse detected — token already consumed 4 hours prior.','2024-08-15 16:05:33','45.33.32.156',NULL),(90010010,'DDOS_SUSPECTED','HIGH','Unusually high request rate from single IP during election window.','2024-10-05 03:22:18','185.220.101.45',NULL);
/*!40000 ALTER TABLE `security_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token`
--

DROP TABLE IF EXISTS `token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token` (
  `token_id` int NOT NULL AUTO_INCREMENT,
  `token_value` varchar(255) NOT NULL,
  `voter_id` int NOT NULL,
  `election_id` int NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT '0',
  `used_at` datetime DEFAULT NULL,
  PRIMARY KEY (`token_id`),
  UNIQUE KEY `uq_token_value` (`token_value`),
  UNIQUE KEY `uq_voter_election` (`voter_id`,`election_id`),
  KEY `idx_token_election` (`election_id`),
  CONSTRAINT `fk_token_election` FOREIGN KEY (`election_id`) REFERENCES `election` (`election_id`),
  CONSTRAINT `fk_token_voter` FOREIGN KEY (`voter_id`) REFERENCES `voter` (`voter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=50227385 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token`
--

LOCK TABLES `token` WRITE;
/*!40000 ALTER TABLE `token` DISABLE KEYS */;
INSERT INTO `token` VALUES (50038291,'TKN-A1B2C3D4E5F6G7H8',12847653,20240001,1,'2024-05-01 09:23:47'),(50047163,'TKN-Z9Y8X7W6V5U4T3S2',47291038,20240002,0,NULL),(50061837,'TKN-K1I2E3T4V5O6K7I8',61038274,20240003,1,'2024-07-10 08:45:22'),(50072946,'TKN-N1G2O3C4B5U6I7N8',72845019,20240003,1,'2024-07-10 10:12:05'),(50083015,'TKN-N1A2M3D4A5N6G7H8',38291647,20240003,1,'2024-07-10 13:37:58'),(50094162,'TKN-M1A2I3P4H5A6N7T8',94016253,20240003,0,NULL),(50105273,'TKN-B2C3D4E5F6G7H8I9',10294857,20240001,1,'2024-05-01 10:00:00'),(50116384,'TKN-C3D4E5F6G7H8I9J0',15769384,20240001,1,'2024-05-01 11:00:00'),(50127495,'TKN-F6G7H8I9J0K1L2M3',11203948,20240002,1,'2024-06-15 09:00:00'),(50138506,'TKN-G7H8I9J0K1L2M3N4',17948356,20240002,1,'2024-06-15 10:00:00'),(50149617,'TKN-H8I9J0K1L2M3N4O5',23485019,20240002,1,'2024-06-15 11:00:00'),(50160728,'TKN-J0K1L2M3N4O5P6Q7',13948576,20240004,1,'2024-08-15 09:00:00'),(50171839,'TKN-K1L2M3N4O5P6Q7R8',19485736,20240004,1,'2024-08-15 10:00:00'),(50182940,'TKN-L2M3N4O5P6Q7R8S9',25748930,20240004,1,'2024-08-15 11:00:00'),(50188461,'TKN-D4E5F6G7H8I9J0K1',21485930,20240001,0,NULL),(50194051,'TKN-M3N4O5P6Q7R8S9T0',31485930,20240004,1,'2024-08-15 14:00:00'),(50199572,'TKN-E5F6G7H8I9J0K1L2',27948201,20240001,0,NULL),(50200683,'TKN-I9J0K1L2M3N4O5P6',29485736,20240002,0,NULL),(50205162,'TKN-N4O5P6Q7R8S9T0U1',37948201,20240004,0,NULL),(50216273,'TKN-O5P6Q7R8S9T0U1V2',14857693,20240005,0,NULL),(50227384,'TKN-P6Q7R8S9T0U1V2W3',20394857,20240005,0,NULL);
/*!40000 ALTER TABLE `token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_election_result`
--

DROP TABLE IF EXISTS `v_election_result`;
/*!50001 DROP VIEW IF EXISTS `v_election_result`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_election_result` AS SELECT 
 1 AS `election_id`,
 1 AS `candidate_id`,
 1 AS `full_name`,
 1 AS `total_votes`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `vote`
--

DROP TABLE IF EXISTS `vote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vote` (
  `vote_id` int NOT NULL AUTO_INCREMENT,
  `token_id` int NOT NULL,
  `candidate_id` int NOT NULL,
  `encrypted_vote` text,
  `vote_timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`vote_id`),
  UNIQUE KEY `uq_vote_token` (`token_id`),
  KEY `idx_vote_candidate` (`candidate_id`),
  CONSTRAINT `fk_vote_candidate` FOREIGN KEY (`candidate_id`) REFERENCES `candidate` (`candidate_id`),
  CONSTRAINT `fk_vote_token` FOREIGN KEY (`token_id`) REFERENCES `token` (`token_id`)
) ENGINE=InnoDB AUTO_INCREMENT=60142185 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vote`
--

LOCK TABLES `vote` WRITE;
/*!40000 ALTER TABLE `vote` DISABLE KEYS */;
INSERT INTO `vote` VALUES (60012847,50038291,30014827,'ENC:sha256$3a7f9c2d1b4e8f5a6c0d2e4b7a9f1c3d','2024-05-01 09:23:47'),(60023961,50061837,30041528,'ENC:sha256$7b3e1a9f4c6d0e2b5a8f1c4d7e0b3a6f','2024-07-10 08:45:22'),(60031074,50072946,30056274,'ENC:sha256$2a5c8e1b4d7f0a3c6e9b2d5f8a1c4e7b','2024-07-10 10:12:05'),(60042185,50083015,30067391,'ENC:sha256$9d2b5e8a1c4f7b0d3e6a9c2f5b8d1e4a','2024-07-10 13:37:58'),(60053296,50105273,30078412,'ENC:sha256$3bfc269594ef649228e9a74bab00f042','2024-05-01 10:00:00'),(60064407,50116384,30089523,'ENC:sha256$fb04dcb6970e4c3d1873de51fd5a50d7','2024-05-01 11:00:00'),(60075518,50127495,30029163,'ENC:sha256$e0d2747b9ab7abb6eb65e0373fa1b428','2024-06-15 09:00:00'),(60086629,50138506,30091634,'ENC:sha256$8e38a1ea5c681c8e9a08f1af465f1f07','2024-06-15 10:00:00'),(60097740,50149617,30102745,'ENC:sha256$ee8616502dd081f3f250cdef1b5f1c40','2024-06-15 11:00:00'),(60108851,50160728,30113856,'ENC:sha256$3e8286044388886ee0875bb280f40fc6','2024-08-15 09:00:00'),(60119962,50171839,30124967,'ENC:sha256$22a706ae67234e9fce89f07dead8e03e','2024-08-15 10:00:00'),(60131073,50182940,30136078,'ENC:sha256$147e82faca64a021f4af180c2acbeaa8','2024-08-15 11:00:00'),(60142184,50194051,30113856,'ENC:sha256$45e56db55964c2ea7d66590766543379','2024-08-15 14:00:00');
/*!40000 ALTER TABLE `vote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voter`
--

DROP TABLE IF EXISTS `voter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voter` (
  `voter_id` int NOT NULL AUTO_INCREMENT,
  `national_id` varchar(50) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL DEFAULT '123456',
  `role` enum('VOTER','ADMIN') NOT NULL DEFAULT 'VOTER',
  `status` enum('PENDING','ACTIVE','SUSPENDED') NOT NULL DEFAULT 'PENDING',
  `registration_date` datetime DEFAULT NULL,
  PRIMARY KEY (`voter_id`),
  UNIQUE KEY `uq_national_id` (`national_id`),
  UNIQUE KEY `uq_email` (`email`),
  UNIQUE KEY `uq_phone` (`phone_number`)
) ENGINE=InnoDB AUTO_INCREMENT=94016254 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voter`
--

LOCK TABLES `voter` WRITE;
/*!40000 ALTER TABLE `voter` DISABLE KEYS */;
INSERT INTO `voter` VALUES (10294857,'NID-1992-KK011','Nguyen Van An','van.an@email.vn','+84901111001','123456','VOTER','ACTIVE','2024-04-01 00:00:00'),(11203948,'NID-1996-LL012','Tran Thi Bao','thi.bao@email.vn','+84901111002','123456','VOTER','ACTIVE','2024-04-02 00:00:00'),(12039485,'NID-1994-MM013','Le Van Cuong','van.cuong@email.vn','+84901111003','123456','VOTER','ACTIVE','2024-04-03 00:00:00'),(12847653,'NID-2001-AA001','Nguyen Thi Lan','lan.nguyen@email.vn','+84901234567','123456','ADMIN','ACTIVE','2024-01-15 00:00:00'),(13948576,'NID-1999-NN014','Pham Thi Dung','thi.dung@email.vn','+84901111004','123456','VOTER','ACTIVE','2024-04-04 00:00:00'),(14857693,'NID-2000-OO015','Hoang Van Em','van.em@email.vn','+84901111005','123456','VOTER','ACTIVE','2024-04-05 00:00:00'),(15728046,'NID-1988-II009','Hoang Duc Thinh','thinh.hoang@email.vn','+84989012345','123456','VOTER','SUSPENDED','2024-03-15 00:00:00'),(15769384,'NID-1991-PP016','Vo Thi Giang','thi.giang@email.vn','+84901111006','123456','VOTER','ACTIVE','2024-04-06 00:00:00'),(16839475,'NID-1987-QQ017','Bui Van Hung','van.hung@email.vn','+84901111007','123456','VOTER','PENDING','2024-04-07 00:00:00'),(17948356,'NID-2001-RR018','Dang Thi Hue','thi.hue@email.vn','+84901111008','123456','VOTER','ACTIVE','2024-04-08 00:00:00'),(18374950,'NID-1995-SS019','Dinh Van Khoi','van.khoi@email.vn','+84901111009','123456','VOTER','ACTIVE','2024-04-09 00:00:00'),(19485736,'NID-1989-TT020','Cao Thi Lan','thi.lan2@email.vn','+84901111010','123456','VOTER','ACTIVE','2024-04-10 00:00:00'),(20394857,'NID-1993-UU021','Nguyen Van Linh','van.linh@email.vn','+84901111011','123456','VOTER','ACTIVE','2024-04-11 00:00:00'),(21485930,'NID-1998-VV022','Tran Thi Mai','thi.mai2@email.vn','+84901111012','123456','VOTER','ACTIVE','2024-04-12 00:00:00'),(22394018,'NID-2002-WW023','Le Van Nam','van.nam@email.vn','+84901111013','123456','VOTER','SUSPENDED','2024-04-13 00:00:00'),(23485019,'NID-1990-XX024','Pham Van Phong','van.phong@email.vn','+84901111014','123456','VOTER','ACTIVE','2024-04-14 00:00:00'),(24839047,'NID-1986-YY025','Hoang Thi Quynh','thi.quynh@email.vn','+84901111015','123456','VOTER','ACTIVE','2024-04-15 00:00:00'),(25748930,'NID-1997-ZZ026','Vo Van Sang','van.sang@email.vn','+84901111016','123456','VOTER','ACTIVE','2024-04-16 00:00:00'),(26839105,'NID-2003-AB027','Bui Thi Tam','thi.tam2@email.vn','+84901111017','123456','VOTER','ACTIVE','2024-04-17 00:00:00'),(27948201,'NID-1994-AC028','Dang Van Thanh','van.thanh@email.vn','+84901111018','123456','VOTER','ACTIVE','2024-04-18 00:00:00'),(29485736,'NID-1988-AE030','Cao Van Tuan','van.tuan@email.vn','+84901111020','123456','VOTER','ACTIVE','2024-04-20 00:00:00'),(30394857,'NID-1996-AF031','Nguyen Thi Uyen','thi.uyen@email.vn','+84901111021','123456','VOTER','ACTIVE','2024-04-21 00:00:00'),(31485930,'NID-1999-AG032','Tran Van Vinh','van.vinh@email.vn','+84901111022','123456','VOTER','ACTIVE','2024-04-22 00:00:00'),(32394018,'NID-2000-AH033','Le Thi Xuan','thi.xuan@email.vn','+84901111023','123456','VOTER','ACTIVE','2024-04-23 00:00:00'),(33485019,'NID-1992-AI034','Pham Van Yen','van.yen@email.vn','+84901111024','123456','VOTER','ACTIVE','2024-04-24 00:00:00'),(35748930,'NID-1993-AK036','Vo Thi Chau','thi.chau@email.vn','+84901111026','123456','VOTER','ACTIVE','2024-04-26 00:00:00'),(36839105,'NID-2001-AL037','Bui Van Dat','van.dat@email.vn','+84901111027','123456','VOTER','ACTIVE','2024-04-27 00:00:00'),(37948201,'NID-1997-AM038','Dang Thi Duyen','thi.duyen@email.vn','+84901111028','123456','VOTER','ACTIVE','2024-04-28 00:00:00'),(38291647,'NID-2002-GG007','Dang Hoang Nam','nam.dang@email.vn','+84967890123','123456','VOTER','ACTIVE','2024-03-10 00:00:00'),(39284756,'NID-1990-AN039','Dinh Van Gia','van.gia@email.vn','+84901111029','123456','VOTER','ACTIVE','2024-04-29 00:00:00'),(40193847,'NID-1987-AO040','Cao Thi Hanh','thi.hanh@email.vn','+84901111030','123456','VOTER','ACTIVE','2024-04-30 00:00:00'),(41928374,'NID-1995-AP041','Nguyen Van Hai','van.hai@email.vn','+84901111031','123456','VOTER','ACTIVE','2024-05-01 00:00:00'),(42837465,'NID-2002-AQ042','Tran Thi Hong','thi.hong@email.vn','+84901111032','123456','VOTER','ACTIVE','2024-05-02 00:00:00'),(44655647,'NID-1994-AS044','Pham Thi Kim','thi.kim@email.vn','+84901111034','123456','VOTER','ACTIVE','2024-05-04 00:00:00'),(45564738,'NID-1998-AT045','Hoang Van Lam','van.lam@email.vn','+84901111035','123456','VOTER','ACTIVE','2024-05-05 00:00:00'),(46473829,'NID-1991-AU046','Vo Thi Linh','thi.linh@email.vn','+84901111036','123456','VOTER','ACTIVE','2024-05-06 00:00:00'),(47291038,'NID-1998-BB002','Tran Van Minh','minh.tran@email.vn','+84912345678','123456','VOTER','ACTIVE','2024-01-20 00:00:00'),(47382910,'NID-2003-AV047','Bui Van Long','van.long@email.vn','+84901111037','123456','VOTER','ACTIVE','2024-05-07 00:00:00'),(48292001,'NID-1996-AW048','Dang Thi Ly','thi.ly@email.vn','+84901111038','123456','VOTER','ACTIVE','2024-05-08 00:00:00'),(50110183,'NID-1999-AY050','Cao Thi Na','thi.na@email.vn','+84901111040','123456','VOTER','ACTIVE','2024-05-10 00:00:00'),(59134782,'NID-1995-DD004','Pham Quoc Bao','bao.pham@email.vn','+84934567890','123456','VOTER','ACTIVE','2024-02-10 00:00:00'),(61038274,'NID-1993-EE005','Vo Van Kiet','kiet.vo@email.vn','+84945678901','123456','VOTER','ACTIVE','2024-03-01 00:00:00'),(72845019,'NID-1997-FF006','Bui Thi Ngoc','ngoc.bui@email.vn','+84956789012','123456','VOTER','ACTIVE','2024-03-05 00:00:00'),(83650214,'NID-2000-CC003','Le Thi Hoa','hoa.le@email.vn','+84923456789','123456','VOTER','SUSPENDED','2024-02-01 00:00:00'),(86304192,'NID-2003-JJ010','Trinh Thi Bich','bich.trinh@email.vn','+84990123456','123456','VOTER','ACTIVE','2024-07-20 00:00:00'),(94016253,'NID-1990-HH008','Phan Thi Mai','mai.phan@email.vn','+84978901234','123456','VOTER','ACTIVE','2024-03-12 00:00:00');
/*!40000 ALTER TABLE `voter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voter_election`
--

DROP TABLE IF EXISTS `voter_election`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voter_election` (
  `voter_id` int NOT NULL,
  `election_id` int NOT NULL,
  `registered_at` datetime DEFAULT NULL,
  `eligibility_status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`voter_id`,`election_id`),
  KEY `idx_ve_election` (`election_id`),
  CONSTRAINT `fk_ve_election` FOREIGN KEY (`election_id`) REFERENCES `election` (`election_id`),
  CONSTRAINT `fk_ve_voter` FOREIGN KEY (`voter_id`) REFERENCES `voter` (`voter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voter_election`
--

LOCK TABLES `voter_election` WRITE;
/*!40000 ALTER TABLE `voter_election` DISABLE KEYS */;
INSERT INTO `voter_election` VALUES (10294857,20240001,'2024-04-10 08:00:00','ELIGIBLE'),(11203948,20240002,'2024-05-15 08:00:00','ELIGIBLE'),(12039485,20240003,'2024-06-05 08:00:00','ELIGIBLE'),(12847653,20240001,'2024-04-01 08:00:00','ELIGIBLE'),(13948576,20240004,'2024-07-20 08:00:00','ELIGIBLE'),(14857693,20240005,'2024-09-15 08:00:00','ELIGIBLE'),(15728046,20240003,'2024-06-03 08:00:00','NOT_ELIGIBLE'),(15769384,20240001,'2024-04-10 08:00:00','ELIGIBLE'),(17948356,20240002,'2024-05-15 08:00:00','ELIGIBLE'),(19485736,20240004,'2024-07-20 08:00:00','ELIGIBLE'),(20394857,20240005,'2024-09-15 08:00:00','ELIGIBLE'),(21485930,20240001,'2024-04-10 08:00:00','ELIGIBLE'),(23485019,20240002,'2024-05-15 08:00:00','ELIGIBLE'),(25748930,20240004,'2024-07-20 08:00:00','ELIGIBLE'),(27948201,20240001,'2024-04-10 08:00:00','ELIGIBLE'),(29485736,20240002,'2024-05-15 08:00:00','ELIGIBLE'),(31485930,20240004,'2024-07-20 08:00:00','ELIGIBLE'),(37948201,20240004,'2024-07-20 08:00:00','ELIGIBLE'),(38291647,20240003,'2024-06-02 10:00:00','ELIGIBLE'),(47291038,20240002,'2024-05-10 10:30:00','ELIGIBLE'),(59134782,20240002,'2024-05-12 14:00:00','ELIGIBLE'),(61038274,20240003,'2024-06-01 09:00:00','ELIGIBLE'),(72845019,20240003,'2024-06-01 09:30:00','ELIGIBLE'),(83650214,20240001,'2024-04-02 09:15:00','NOT_ELIGIBLE'),(86304192,20240003,'2024-07-20 16:00:00','NOT_ELIGIBLE'),(94016253,20240003,'2024-06-02 11:00:00','ELIGIBLE');
/*!40000 ALTER TABLE `voter_election` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `v_election_result`
--

/*!50001 DROP VIEW IF EXISTS `v_election_result`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_election_result` AS select `c`.`election_id` AS `election_id`,`c`.`candidate_id` AS `candidate_id`,`c`.`full_name` AS `full_name`,count(`v`.`vote_id`) AS `total_votes` from (`candidate` `c` left join `vote` `v` on((`v`.`candidate_id` = `c`.`candidate_id`))) group by `c`.`election_id`,`c`.`candidate_id`,`c`.`full_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-04 22:01:24
