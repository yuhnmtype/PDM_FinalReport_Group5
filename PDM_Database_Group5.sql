-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: onlinevotingsystem
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
  KEY `voter_id` (`voter_id`),
  CONSTRAINT `audit_log_ibfk_1` FOREIGN KEY (`voter_id`) REFERENCES `voter` (`voter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=80930417 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
INSERT INTO `audit_log` VALUES (80001111,12847653,'LOGIN','2024-05-01 09:15:00','Voter authenticated via OTP from IP 103.21.44.12'),(80002222,12847653,'TOKEN_ISSUED','2024-05-01 09:20:00','One-time token 50038291 generated for election 20240001'),(80003333,12847653,'VOTE_CAST','2024-05-01 09:23:47','Vote recorded for candidate 30014827 in election 20240001'),(80004444,12847653,'LOGOUT','2024-05-01 09:25:10','Session terminated normally'),(80005555,47291038,'LOGIN','2024-06-10 11:00:00','Voter authenticated via OTP from IP 118.69.72.55'),(80006661,61038274,'LOGIN','2024-07-10 08:30:00','Voter authenticated via OTP from IP 113.190.22.14'),(80007772,61038274,'TOKEN_ISSUED','2024-07-10 08:40:00','One-time token 50061837 generated for election 20240003'),(80008883,61038274,'VOTE_CAST','2024-07-10 08:45:22','Vote recorded for candidate 30041528 in election 20240003'),(80009994,61038274,'LOGOUT','2024-07-10 08:47:00','Session terminated normally'),(80010005,72845019,'LOGIN','2024-07-10 10:00:00','Voter authenticated via OTP from IP 118.71.55.30'),(80011116,72845019,'TOKEN_ISSUED','2024-07-10 10:08:00','One-time token 50072946 generated for election 20240003'),(80012227,72845019,'VOTE_CAST','2024-07-10 10:12:05','Vote recorded for candidate 30056274 in election 20240003'),(80013338,72845019,'LOGOUT','2024-07-10 10:14:30','Session terminated normally'),(80014449,38291647,'LOGIN','2024-07-10 13:20:00','Voter authenticated via OTP from IP 222.252.14.60'),(80015550,38291647,'TOKEN_ISSUED','2024-07-10 13:30:00','One-time token 50083015 generated for election 20240003'),(80016661,38291647,'VOTE_CAST','2024-07-10 13:37:58','Vote recorded for candidate 30067391 in election 20240003'),(80017772,38291647,'LOGOUT','2024-07-10 13:40:00','Session terminated normally'),(80018883,94016253,'LOGIN','2024-07-10 14:55:00','Voter authenticated via OTP from IP 103.90.220.8'),(80019994,94016253,'TOKEN_ISSUED','2024-07-10 15:00:00','One-time token 50094162 generated for election 20240003'),(80930413,12847653,'LOGIN','2026-05-03 20:45:57','Login from UI'),(80930414,12847653,'LOGIN','2026-05-03 20:48:29','Login from UI'),(80930415,12847653,'LOGIN','2026-05-03 20:49:51','Login from UI'),(80930416,12847653,'LOGIN','2026-05-03 21:07:03','Login from UI');
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ballot`
--

DROP TABLE IF EXISTS `ballot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ballot` (
  `ballot_id` int NOT NULL AUTO_INCREMENT,
  `election_id` int DEFAULT NULL,
  `ballot_type` varchar(50) DEFAULT NULL,
  `language` varchar(50) DEFAULT NULL,
  `accessibility_option` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ballot_id`),
  KEY `election_id` (`election_id`),
  CONSTRAINT `ballot_ibfk_1` FOREIGN KEY (`election_id`) REFERENCES `election` (`election_id`)
) ENGINE=InnoDB AUTO_INCREMENT=93041507 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ballot`
--

LOCK TABLES `ballot` WRITE;
/*!40000 ALTER TABLE `ballot` DISABLE KEYS */;
INSERT INTO `ballot` VALUES (40018374,20240001,'SINGLE_CHOICE','Vietnamese','SCREEN_READER'),(40029651,20240002,'SINGLE_CHOICE','Vietnamese','LARGE_PRINT'),(40036827,20240003,'SINGLE_CHOICE','Vietnamese','AUDIO_DESCRIPTION');
/*!40000 ALTER TABLE `ballot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate`
--

DROP TABLE IF EXISTS `candidate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate` (
  `candidate_id` int NOT NULL AUTO_INCREMENT,
  `election_id` int DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `party_affiliation` varchar(100) DEFAULT NULL,
  `manifesto` text,
  PRIMARY KEY (`candidate_id`),
  KEY `election_id` (`election_id`),
  CONSTRAINT `candidate_ibfk_1` FOREIGN KEY (`election_id`) REFERENCES `election` (`election_id`)
) ENGINE=InnoDB AUTO_INCREMENT=66677789 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate`
--

LOCK TABLES `candidate` WRITE;
/*!40000 ALTER TABLE `candidate` DISABLE KEYS */;
INSERT INTO `candidate` VALUES (30014827,20240001,'Vo Thi Thu','People Democratic Party','Strengthen rural infrastructure and healthcare access for all citizens.'),(30029163,20240002,'Nguyen Duc Long','Progressive Alliance','Invest in renewable energy and modernise provincial transport networks.'),(30041528,20240003,'Cao Thi Phuong','National Unity Front','Expand public education funding and build new community learning centres.'),(30056274,20240003,'Dinh Van Hung','People Democratic Party','Boost local economy through small business grants and farmer subsidies.'),(30067391,20240003,'Le Minh Quan','Progressive Alliance','Modernise district healthcare with digital records and telemedicine access.');
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
  `election_name` varchar(100) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('UPCOMING','ACTIVE','CLOSED','VERIFIED') NOT NULL,
  PRIMARY KEY (`election_id`)
) ENGINE=InnoDB AUTO_INCREMENT=90167855 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `election`
--

LOCK TABLES `election` WRITE;
/*!40000 ALTER TABLE `election` DISABLE KEYS */;
INSERT INTO `election` VALUES (20240001,'National Assembly Election 2024','2024-05-01','2024-05-01','VERIFIED'),(20240002,'Provincial Council Election 2024','2024-06-15','2024-06-15','ACTIVE'),(20240003,'District People Committee Election 2024','2024-07-10','2024-07-10','CLOSED');
/*!40000 ALTER TABLE `election` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `election_result`
--

DROP TABLE IF EXISTS `election_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `election_result` (
  `result_id` int NOT NULL AUTO_INCREMENT,
  `election_id` int DEFAULT NULL,
  `candidate_id` int DEFAULT NULL,
  `total_votes` int DEFAULT NULL,
  `verified_status` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`result_id`),
  UNIQUE KEY `uq_result` (`election_id`,`candidate_id`),
  KEY `candidate_id` (`candidate_id`),
  CONSTRAINT `election_result_ibfk_1` FOREIGN KEY (`election_id`) REFERENCES `election` (`election_id`),
  CONSTRAINT `election_result_ibfk_2` FOREIGN KEY (`candidate_id`) REFERENCES `candidate` (`candidate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=70005679 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `election_result`
--

LOCK TABLES `election_result` WRITE;
/*!40000 ALTER TABLE `election_result` DISABLE KEYS */;
INSERT INTO `election_result` VALUES (70001234,20240001,30014827,1,1),(70002345,20240002,30029163,0,0),(70003456,20240003,30041528,1,0),(70004567,20240003,30056274,1,0),(70005678,20240003,30067391,1,0);
/*!40000 ALTER TABLE `election_result` ENABLE KEYS */;
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
  KEY `voter_id` (`voter_id`),
  CONSTRAINT `security_event_ibfk_1` FOREIGN KEY (`voter_id`) REFERENCES `voter` (`voter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=90004005 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `security_event`
--

LOCK TABLES `security_event` WRITE;
/*!40000 ALTER TABLE `security_event` DISABLE KEYS */;
INSERT INTO `security_event` VALUES (90001001,'UNAUTHORISED_ACCESS_ATTEMPT','HIGH','Suspended voter 83650214 attempted to log in during election 20240001.','2024-05-01 08:47:33','27.72.98.41',83650214),(90002002,'BRUTE_FORCE_DETECTED','CRITICAL','Multiple rapid login attempts detected against voter account 12847653 from foreign IP.','2024-05-01 09:10:55','185.220.101.73',12847653),(90003003,'UNAUTHORISED_ACCESS_ATTEMPT','HIGH','Suspended voter 15728046 attempted to authenticate during election 20240003.','2024-07-10 09:05:14','14.177.243.85',15728046),(90004004,'POLICY_VIOLATION','MEDIUM','Pending voter 86304192 attempted to access ballot before eligibility was confirmed.','2024-07-10 11:22:47','103.97.125.60',86304192);
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
  `token_value` varchar(255) DEFAULT NULL,
  `election_id` int DEFAULT NULL,
  `ballot_id` int DEFAULT NULL,
  `is_used` tinyint(1) DEFAULT '0',
  `used_at` datetime DEFAULT NULL,
  PRIMARY KEY (`token_id`),
  UNIQUE KEY `token_value` (`token_value`),
  KEY `election_id` (`election_id`),
  KEY `ballot_id` (`ballot_id`),
  CONSTRAINT `token_ibfk_1` FOREIGN KEY (`election_id`) REFERENCES `election` (`election_id`),
  CONSTRAINT `token_ibfk_2` FOREIGN KEY (`ballot_id`) REFERENCES `ballot` (`ballot_id`)
) ENGINE=InnoDB AUTO_INCREMENT=81726355 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token`
--

LOCK TABLES `token` WRITE;
/*!40000 ALTER TABLE `token` DISABLE KEYS */;
INSERT INTO `token` VALUES (50038291,'TKN-A1B2C3D4E5F6G7H8',20240001,40018374,1,'2024-05-01 09:23:47'),(50047163,'TKN-Z9Y8X7W6V5U4T3S2',20240002,40029651,0,NULL),(50061837,'TKN-K1I2E3T4V5O6K7I8',20240003,40036827,1,'2024-07-10 08:45:22'),(50072946,'TKN-N1G2O3C4B5U6I7N8',20240003,40036827,1,'2024-07-10 10:12:05'),(50083015,'TKN-N1A2M3D4A5N6G7H8',20240003,40036827,1,'2024-07-10 13:37:58'),(50094162,'TKN-M1A2I3P4H5A6N7T8',20240003,40036827,0,NULL);
/*!40000 ALTER TABLE `token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vote`
--

DROP TABLE IF EXISTS `vote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vote` (
  `vote_id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int DEFAULT NULL,
  `election_id` int DEFAULT NULL,
  `ballot_id` int DEFAULT NULL,
  `token_id` int DEFAULT NULL,
  `encrypted_vote` text,
  `vote_timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`vote_id`),
  UNIQUE KEY `token_id` (`token_id`),
  KEY `candidate_id` (`candidate_id`),
  KEY `election_id` (`election_id`),
  KEY `ballot_id` (`ballot_id`),
  CONSTRAINT `vote_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate` (`candidate_id`),
  CONSTRAINT `vote_ibfk_2` FOREIGN KEY (`election_id`) REFERENCES `election` (`election_id`),
  CONSTRAINT `vote_ibfk_3` FOREIGN KEY (`ballot_id`) REFERENCES `ballot` (`ballot_id`),
  CONSTRAINT `vote_ibfk_4` FOREIGN KEY (`token_id`) REFERENCES `token` (`token_id`)
) ENGINE=InnoDB AUTO_INCREMENT=91827365 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vote`
--

LOCK TABLES `vote` WRITE;
/*!40000 ALTER TABLE `vote` DISABLE KEYS */;
INSERT INTO `vote` VALUES (60012847,30014827,20240001,40018374,50038291,'ENC:sha256$3a7f9c2d1b4e8f5a6c0d2e4b7a9f1c3d5e7b2a4f6c8d0e2b4a6f8c0d2e4b6a','2024-05-01 09:23:47'),(60023961,30041528,20240003,40036827,50061837,'ENC:sha256$7b3e1a9f4c6d0e2b5a8f1c4d7e0b3a6f9c2e5b8a1d4f7c0e3b6a9f2c5e8b1d4','2024-07-10 08:45:22'),(60031074,30056274,20240003,40036827,50072946,'ENC:sha256$2a5c8e1b4d7f0a3c6e9b2d5f8a1c4e7b0d3f6a9c2e5b8a1d4f7c0e3b6a9f2c5','2024-07-10 10:12:05'),(60042185,30067391,20240003,40036827,50083015,'ENC:sha256$9d2b5e8a1c4f7b0d3e6a9c2f5b8d1e4a7c0f3b6a9d2e5c8b1a4f7d0e3c6b9a2','2024-07-10 13:37:58');
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
  `national_id` varchar(50) DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL DEFAULT '123456',
  `phone_number` varchar(20) DEFAULT NULL,
  `registration_date` datetime DEFAULT NULL,
  `status` enum('PENDING','ACTIVE','SUSPENDED','DEACTIVATED') NOT NULL DEFAULT 'PENDING',
  PRIMARY KEY (`voter_id`),
  UNIQUE KEY `national_id` (`national_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=1029384757 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voter`
--

LOCK TABLES `voter` WRITE;
/*!40000 ALTER TABLE `voter` DISABLE KEYS */;
INSERT INTO `voter` VALUES (12847653,'NID-2001-AA001','Nguyen Thi Lan','lan.nguyen@email.vn','123456','+84901234567','2024-01-15 00:00:00','ACTIVE'),(15728046,'NID-1988-II009','Hoang Duc Thinh','thinh.hoang@email.vn','123456','+84989012345','2024-03-15 00:00:00','SUSPENDED'),(38291647,'NID-2002-GG007','Dang Hoang Nam','nam.dang@email.vn','123456','+84967890123','2024-03-10 00:00:00','ACTIVE'),(47291038,'NID-1998-BB002','Tran Van Minh','minh.tran@email.vn','123456','+84912345678','2024-01-20 00:00:00','ACTIVE'),(59134782,'NID-1995-DD004','Pham Quoc Bao','bao.pham@email.vn','123456','+84934567890','2024-02-10 00:00:00','ACTIVE'),(61038274,'NID-1993-EE005','Vo Van Kiet','kiet.vo@email.vn','123456','+84945678901','2024-03-01 00:00:00','ACTIVE'),(72845019,'NID-1997-FF006','Bui Thi Ngoc','ngoc.bui@email.vn','123456','+84956789012','2024-03-05 00:00:00','ACTIVE'),(83650214,'NID-2000-CC003','Le Thi Hoa','hoa.le@email.vn','123456','+84923456789','2024-02-01 00:00:00','SUSPENDED'),(86304192,'NID-2003-JJ010','Trinh Thi Bich','bich.trinh@email.vn','123456','+84990123456','2024-07-20 00:00:00','PENDING'),(94016253,'NID-1990-HH008','Phan Thi Mai','mai.phan@email.vn','123456','+84978901234','2024-03-12 00:00:00','ACTIVE');
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
  `has_voted` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`voter_id`,`election_id`),
  KEY `election_id` (`election_id`),
  CONSTRAINT `voter_election_ibfk_1` FOREIGN KEY (`voter_id`) REFERENCES `voter` (`voter_id`),
  CONSTRAINT `voter_election_ibfk_2` FOREIGN KEY (`election_id`) REFERENCES `election` (`election_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voter_election`
--

LOCK TABLES `voter_election` WRITE;
/*!40000 ALTER TABLE `voter_election` DISABLE KEYS */;
INSERT INTO `voter_election` VALUES (12847653,20240001,'2024-04-01 08:00:00','ELIGIBLE',1),(15728046,20240003,'2024-06-03 08:00:00','NOT_ELIGIBLE',0),(38291647,20240003,'2024-06-02 10:00:00','ELIGIBLE',1),(47291038,20240002,'2024-05-10 10:30:00','ELIGIBLE',0),(59134782,20240002,'2024-05-12 14:00:00','ELIGIBLE',0),(61038274,20240003,'2024-06-01 09:00:00','ELIGIBLE',1),(72845019,20240003,'2024-06-01 09:30:00','ELIGIBLE',1),(83650214,20240001,'2024-04-02 09:15:00','NOT_ELIGIBLE',0),(86304192,20240003,'2024-07-20 16:00:00','NOT_ELIGIBLE',0),(94016253,20240003,'2024-06-02 11:00:00','ELIGIBLE',0);
/*!40000 ALTER TABLE `voter_election` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-03 21:28:45
