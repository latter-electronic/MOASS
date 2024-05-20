-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: k10e203.p.ssafy.io    Database: moass_service
-- ------------------------------------------------------
-- Server version	5.5.5-10.6.16-MariaDB-1:10.6.16+maria~ubu2004

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
-- Table structure for table `Board`
--

DROP TABLE IF EXISTS `Board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Board` (
  `board_id` int(11) NOT NULL AUTO_INCREMENT,
  `board_name` varchar(255) DEFAULT NULL,
  `board_url` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `completed_at` timestamp NOT NULL DEFAULT utc_timestamp(),
  PRIMARY KEY (`board_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Board`
--

LOCK TABLES `Board` WRITE;
/*!40000 ALTER TABLE `Board` DISABLE KEYS */;
INSERT INTO `Board` VALUES (1,NULL,'http://k10e203.p.ssafy.io:5001/boards/3e38df62-0ac0-45b9-b828-1a3bbc0c657a',NULL,'2024-05-19 23:43:15'),(2,NULL,'http://k10e203.p.ssafy.io:5001/boards/c7cf3ce3-d8ca-4cd7-b542-4f3de3fecff3',NULL,'2024-05-19 23:44:45'),(3,NULL,'http://k10e203.p.ssafy.io:5001/boards/76d4630f-ac7f-4985-80d2-b47e1b3b2a28',NULL,'2024-05-20 00:25:27'),(4,NULL,'http://k10e203.p.ssafy.io:5001/boards/2b4465df-79c1-4d26-8084-fb27e5d465c2',NULL,'2024-05-20 00:26:16'),(5,NULL,'http://k10e203.p.ssafy.io:5001/boards/85ffbb7a-4fbf-4bed-862e-4a61b80188c3',NULL,'2024-05-20 02:04:10');
/*!40000 ALTER TABLE `Board` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BoardUser`
--

DROP TABLE IF EXISTS `BoardUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BoardUser` (
  `board_user_id` int(11) NOT NULL AUTO_INCREMENT,
  `board_id` int(11) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  PRIMARY KEY (`board_user_id`),
  KEY `user_id` (`user_id`),
  KEY `board_id` (`board_id`),
  CONSTRAINT `BoardUser_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`),
  CONSTRAINT `BoardUser_ibfk_2` FOREIGN KEY (`board_id`) REFERENCES `Board` (`board_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BoardUser`
--

LOCK TABLES `BoardUser` WRITE;
/*!40000 ALTER TABLE `BoardUser` DISABLE KEYS */;
INSERT INTO `BoardUser` VALUES (1,1,'1052881'),(2,2,'1052881'),(3,1,'1057753'),(4,1,'1058448'),(5,2,'1058448'),(6,2,'1057753'),(7,3,'1057753'),(8,4,'1052881'),(9,5,'1052881');
/*!40000 ALTER TABLE `BoardUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Class`
--

DROP TABLE IF EXISTS `Class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Class` (
  `class_code` varchar(5) NOT NULL,
  `location_code` varchar(5) NOT NULL,
  PRIMARY KEY (`class_code`),
  KEY `location_code` (`location_code`),
  CONSTRAINT `Class_ibfk_1` FOREIGN KEY (`location_code`) REFERENCES `Location` (`location_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Class`
--

LOCK TABLES `Class` WRITE;
/*!40000 ALTER TABLE `Class` DISABLE KEYS */;
INSERT INTO `Class` VALUES ('A1','A'),('A2','A'),('A3','A'),('A4','A'),('A5','A'),('A6','A'),('A7','A'),('B1','B'),('B2','B'),('B3','B'),('C1','C'),('C2','C'),('D1','D'),('D2','D'),('E1','E'),('E2','E'),('Z1','Z'),('Z10','Z'),('Z2','Z'),('Z3','Z'),('Z4','Z'),('Z5','Z'),('Z6','Z'),('Z7','Z'),('Z8','Z'),('Z9','Z');
/*!40000 ALTER TABLE `Class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Device`
--

DROP TABLE IF EXISTS `Device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Device` (
  `device_id` varchar(40) NOT NULL,
  `user_id` varchar(20) DEFAULT NULL,
  `x_coord` int(11) DEFAULT NULL,
  `y_coord` int(11) DEFAULT NULL,
  `class_code` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`device_id`),
  KEY `user_id` (`user_id`),
  KEY `class_code` (`class_code`),
  CONSTRAINT `Device_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`),
  CONSTRAINT `Device_ibfk_2` FOREIGN KEY (`class_code`) REFERENCES `Class` (`class_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Device`
--

LOCK TABLES `Device` WRITE;
/*!40000 ALTER TABLE `Device` DISABLE KEYS */;
INSERT INTO `Device` VALUES ('10000000ee105777','1052881',333,876,'E2'),('DDDD1',NULL,NULL,NULL,NULL),('DDDD2',NULL,NULL,NULL,'E2'),('DDDD3',NULL,NULL,NULL,NULL),('DDDD4',NULL,NULL,NULL,NULL),('DDDD5',NULL,NULL,NULL,'E2'),('E10017','1050017',86,490,'E2'),('E20011','1050011',36,190,'E2'),('E20012','1050012',36,290,'E2'),('E20013','1050013',36,390,'E2'),('E20014','1050014',136,190,'E2'),('E20015','1050015',136,290,'E2'),('E20016','1050016',136,390,'E2'),('E20031','1050031',36,1104,'E2'),('E20032','1050032',36,1204,'E2'),('E20033','1050033',36,1304,'E2'),('E20034','1050034',136,1104,'E2'),('E20035','1050035',136,1204,'E2'),('E20036','1050036',136,1304,'E2'),('E20041','1050041',381,489,'E2'),('E20042','1050042',381,589,'E2'),('E20043','1050043',381,689,'E2'),('E20044','1050044',481,489,'E2'),('E20045','1050045',481,589,'E2'),('E20046','1050046',481,689,'E2'),('E20051','1050051',718,190,'E2'),('E20052','1050052',718,290,'E2'),('E20053','1050053',718,390,'E2'),('E20054','1050054',818,190,'E2'),('E20055','1050055',818,290,'E2'),('E20056','1050056',818,390,'E2'),('E20061','1050061',718,647,'E2'),('E20062','1050062',718,747,'E2'),('E20063','1050063',718,847,'E2'),('E20064','1050064',818,647,'E2'),('E20065','1050065',818,747,'E2'),('E20066','1050066',818,847,'E2'),('E20071','1050071',718,1104,'E2'),('E20072','1050072',718,1204,'E2'),('E20073','1050073',718,1304,'E2'),('E20074','1050074',818,1104,'E2'),('E20075','1050075',818,1204,'E2'),('E20076','1050076',818,1304,'E2'),('E20077','1050077',718,1004,'E2');
/*!40000 ALTER TABLE `Device` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FcmToken`
--

DROP TABLE IF EXISTS `FcmToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FcmToken` (
  `fcm_token_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(20) NOT NULL,
  `mobile_device_id` varchar(50) NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT utc_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT utc_timestamp(),
  PRIMARY KEY (`fcm_token_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `FcmToken_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FcmToken`
--

LOCK TABLES `FcmToken` WRITE;
/*!40000 ALTER TABLE `FcmToken` DISABLE KEYS */;
INSERT INTO `FcmToken` VALUES (4,'1055605','d8d32143f4e88bec',NULL,'2024-05-19 06:55:31','2024-05-19 06:55:31'),(5,'1058706','3f6325f020cf09d3','fj_gKqXBTDGaNISe3hgvzW:APA91bGt6dVqYAW9H8vEQajMPtjft33MJNk6o_0_1Yy-JGSlnSs9GVkfptNtqAa-WgpUYUSdGc0c8-afzqeaoliHhB73Fb2-hQiNXRJn9l8x2-R9LxO4fWzlM0Cc6fGmYUSrcgnKEPr6','2024-05-19 07:18:39','2024-05-19 07:18:39'),(6,'1000000','d8d32143f4e88bec',NULL,'2024-05-19 07:59:09','2024-05-19 07:59:09'),(8,'1000000','aa257a5da627158d','evg1KoSHSkaiFx2RmdNQpg:APA91bFjZ3j_FdOxv_V6o0yZUMrBn6fn1oO9rgXBL2nXijXhAoUw6J9ClyhjHSCcXSXz9-5SuI51gJXyH1oEMZJIkTm8_IgRz8Csg95THEHy3PGylxuS8PgKtCmItcN1WKs9QWm0uE2Z','2024-05-19 10:56:06','2024-05-19 10:56:06'),(9,'1058448','4b5fd5b4ce587afd','d40op4AFSO-LCmqhViMH51:APA91bGt5mB0KO1Wd3WPlqDQgXxIOjAWZxXS8uOiBbnBRmFUq6M7oT4Fv_bq1anNrP3XSWVbMox7spHFFvQOTAODjv8cUfhXMlOZWPexAmo3C0Yzj36UUI6gnlYyklNOHif2c5QYWYjw','2024-05-19 11:08:25','2024-05-19 11:08:25'),(10,'1052881','da70dcc5b2187707',NULL,'2024-05-19 11:59:18','2024-05-19 11:59:18'),(11,'1000000','da70dcc5b2187707',NULL,'2024-05-19 12:33:57','2024-05-19 12:33:57'),(12,'1052881','d8d32143f4e88bec','cV6V5lXoSNiGdqqHmUKn9v:APA91bHRRWKfrGbJkiLp7sKVUdjXcZM6L6sWmxRD4BeM78Bt0IvHIAISKtZof348hZPGlDoPy1PR3PO-pv9RQWAJAWBvQXajuo2Uu25OWutSvg0D3phBETP0lsrQTfXfhdLNU8LMwhHx','2024-05-19 11:01:24','2024-05-19 11:01:24'),(13,'1052881','c16d35b5029e7470','cMoJaUQBTdaxRyt9q7Q2kM:APA91bF7NVWXZnsclBe9W6UpAhUVhHfjTgpLwSYszmxR2Nm4tax7S7vf_60_q8u1qeQ-sRzVOVwckle1qEPlsVnpRElSAR44FhH2pJZi29GExN3Tt5iMl7yVQSebIrjWV0LPuG6TAhZg','2024-05-19 14:55:14','2024-05-19 14:55:14'),(14,'1058448','de4c48b87c7cd2d3','eDqSi4CCQM-gEMtJp6KLqe:APA91bEhjv72iNQG-hraC-NW9tf2ewhaDOl33632tydOsyPm9fH2Cx5Qe9ESf6M9vctpwJ2SaFo-0tpFsdkevj0_mtoPNatJKghxYgro_BJc1eSHYaX3NjaX4ORyfnItU3T6ygsmXs1U','2024-05-19 15:56:05','2024-05-19 15:56:05'),(15,'1053374','da70dcc5b2187707','e2tKhqjhSNSr_Zy0I_nrWp:APA91bFZ1_tm635-Ysu_8tZ6XuU8Z_7c2d4vBgFgPwD9X-0wcXDHmrM-OI9PnFVNzGKtSn1-EIeSh1Tv6r1Bok-qYQmA67t6zkmzmA6_F0Lmn4K1edvLte7GWve3GwUFbO-hshYnoQYY','2024-05-19 18:45:29','2024-05-19 18:45:29');
/*!40000 ALTER TABLE `FcmToken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GitlabHook`
--

DROP TABLE IF EXISTS `GitlabHook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GitlabHook` (
  `gitlab_hook_id` varchar(36) NOT NULL,
  `team_code` varchar(5) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT utc_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT utc_timestamp(),
  PRIMARY KEY (`gitlab_hook_id`),
  KEY `team_code` (`team_code`),
  CONSTRAINT `GitlabHook_ibfk_1` FOREIGN KEY (`team_code`) REFERENCES `Team` (`team_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GitlabHook`
--

LOCK TABLES `GitlabHook` WRITE;
/*!40000 ALTER TABLE `GitlabHook` DISABLE KEYS */;
/*!40000 ALTER TABLE `GitlabHook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GitlabProject`
--

DROP TABLE IF EXISTS `GitlabProject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GitlabProject` (
  `gitlab_project_id` varchar(8) NOT NULL,
  `gitlab_token_id` int(11) NOT NULL,
  `gitlab_project_name` varchar(30) NOT NULL,
  PRIMARY KEY (`gitlab_project_id`),
  KEY `gitlab_token_id` (`gitlab_token_id`),
  CONSTRAINT `GitlabProject_ibfk_1` FOREIGN KEY (`gitlab_token_id`) REFERENCES `GitlabToken` (`gitlab_token_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GitlabProject`
--

LOCK TABLES `GitlabProject` WRITE;
/*!40000 ALTER TABLE `GitlabProject` DISABLE KEYS */;
INSERT INTO `GitlabProject` VALUES ('627542',2,'S10P31E203');
/*!40000 ALTER TABLE `GitlabProject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GitlabToken`
--

DROP TABLE IF EXISTS `GitlabToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GitlabToken` (
  `gitlab_token_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(20) NOT NULL,
  `gitlab_email` varchar(50) NOT NULL,
  `access_token` longtext NOT NULL,
  `refresh_token` longtext NOT NULL,
  `expires_at` timestamp NOT NULL DEFAULT (utc_timestamp() + interval 2 hour),
  `created_at` timestamp NOT NULL DEFAULT utc_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT utc_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`gitlab_token_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `GitlabToken_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GitlabToken`
--

LOCK TABLES `GitlabToken` WRITE;
/*!40000 ALTER TABLE `GitlabToken` DISABLE KEYS */;
INSERT INTO `GitlabToken` VALUES (1,'1053374','kain9101@naver.com','0983f18d9a9dd4790db6e0cbb0acf006ddc962e66055e053fc877b7cbd7610d8','ce2fadb17db7c77a03238f879cb9b4de2ed65746cf81e37b73924c00c937b4b2','2024-05-19 11:38:31','2024-05-19 09:37:44','2024-05-19 09:37:44'),(2,'1052881','kain9101@naver.com','05f12a8449b33053414eda2288a5fa41ef82297524d76e9cb9400ff14ed27d77','7181fa2bf1b6408d8d79cf4f5521c84a15af38bda6ff58d6765007a8bd4e3d14','2024-05-19 19:06:41','2024-05-19 11:59:42','2024-05-19 20:08:05'),(3,'1058448','weon1009@gmail.com','9ada938b9aae02e649f58be78b6c62e7968caae265d2fd6e7cf142c5cb7c2ba5','75e8c2162f849c6f22b160d6edb2ebaafcbbd566b85bb254fc692bd481cfc1be','2024-05-19 12:54:10','2024-05-19 10:54:10','2024-05-19 10:54:10');
/*!40000 ALTER TABLE `GitlabToken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `JiraToken`
--

DROP TABLE IF EXISTS `JiraToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `JiraToken` (
  `jira_token_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(20) NOT NULL,
  `cloud_id` varchar(50) NOT NULL,
  `jira_email` varchar(50) NOT NULL,
  `access_token` longtext NOT NULL,
  `refresh_token` longtext NOT NULL,
  `expires_at` timestamp NOT NULL DEFAULT (utc_timestamp() + interval 1 hour),
  `created_at` timestamp NOT NULL DEFAULT utc_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT utc_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`jira_token_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `JiraToken_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `JiraToken`
--

LOCK TABLES `JiraToken` WRITE;
/*!40000 ALTER TABLE `JiraToken` DISABLE KEYS */;
INSERT INTO `JiraToken` VALUES (1,'1053374','15a21def-11f5-4358-ab48-074194685963','kain9101@naver.com','eyJraWQiOiJhdXRoLmF0bGFzc2lhbi5jb20tQUNDRVNTLWE5Njg0YTZlLTY4MjctNGQ1Yi05MzhjLWJkOTZjYzBiOTk0ZCIsImFsZyI6IlJTMjU2In0.eyJqdGkiOiI0MDc5Njc0NS0zY2M4LTQ2ZTktYmQwMi05OTJiZjg5MTBiYTYiLCJzdWIiOiI3MTIwMjA6M2MwNWYzMTgtZTc3MC00MTA1LWE0NjktOWU5Y2VhY2Q5ZTlhIiwibmJmIjoxNzE2MTExNTcxLCJpc3MiOiJodHRwczovL2F1dGguYXRsYXNzaWFuLmNvbSIsImlhdCI6MTcxNjExMTU3MSwiZXhwIjoxNzE2MTE1MTcxLCJhdWQiOiJYcjc2NTNjMktST2h0clhkelJ4aFNRODZwa3hBZzRQSCIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS9ydGkiOiI3MTc5ZDc4Zi1hYWIyLTQ5ODAtODU4My04ZjZhZjhjMmFlYmUiLCJodHRwczovL2F0bGFzc2lhbi5jb20vc3lzdGVtQWNjb3VudEVtYWlsIjoiNjQzNzUwODctZDBkMi00YmY4LWE2M2MtYzMwN2Y2MDJlMGRhQGNvbm5lY3QuYXRsYXNzaWFuLmNvbSIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS91anQiOiI1YWJkNWY0Mi03MTg2LTQ4MzctODk5ZS1lMjI1NTM1Y2NiZWUiLCJodHRwczovL2lkLmF0bGFzc2lhbi5jb20vYXRsX3Rva2VuX3R5cGUiOiJBQ0NFU1MiLCJodHRwczovL2F0bGFzc2lhbi5jb20vZmlyc3RQYXJ0eSI6ZmFsc2UsImh0dHBzOi8vYXRsYXNzaWFuLmNvbS92ZXJpZmllZCI6dHJ1ZSwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tL29hdXRoQ2xpZW50SWQiOiJYcjc2NTNjMktST2h0clhkelJ4aFNRODZwa3hBZzRQSCIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS9yZWZyZXNoX2NoYWluX2lkIjoiWHI3NjUzYzJLUk9odHJYZHpSeGhTUTg2cGt4QWc0UEgtNzEyMDIwOjNjMDVmMzE4LWU3NzAtNDEwNS1hNDY5LTllOWNlYWNkOWU5YS1kODcyNjkwOS0yYmM5LTQzYTItODY3Yy0zOGUwNWEzMGNhODciLCJodHRwczovL2lkLmF0bGFzc2lhbi5jb20vcHJvY2Vzc1JlZ2lvbiI6InVzLXdlc3QtMiIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS9zZXNzaW9uX2lkIjoiZDFlYWMyNzItMzhkNC00NGZiLTg2M2QtY2Y1Mjg2NDg0NDNjIiwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tL2VtYWlsRG9tYWluIjoibmF2ZXIuY29tIiwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tLzNsbyI6dHJ1ZSwiaHR0cHM6Ly9pZC5hdGxhc3NpYW4uY29tL3ZlcmlmaWVkIjp0cnVlLCJzY29wZSI6InJlYWQ6amlyYS13b3JrIG9mZmxpbmVfYWNjZXNzIHdyaXRlOmppcmEtd29yayByZWFkOmppcmEtdXNlciIsImNsaWVudF9pZCI6IlhyNzY1M2MyS1JPaHRyWGR6UnhoU1E4NnBreEFnNFBIIiwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tL3N5c3RlbUFjY291bnRFbWFpbERvbWFpbiI6ImNvbm5lY3QuYXRsYXNzaWFuLmNvbSIsImh0dHBzOi8vYXRsYXNzaWFuLmNvbS9zeXN0ZW1BY2NvdW50SWQiOiI3MTIwMjA6ZmM4YjhjYjgtYWU5YS00ZjFjLWE2ZjItMjNkMjEzZjc0OGMzIn0.DmBdBGyQ-mjS2LEHao6RV3yCP-e3KPRSBlUAetQ5nMGj6K7q-iFfU8lDWUfeoeDeDhS3dRcBC0l2gV4aqLz9IkofVmWfz7zUoEelTk9FD0EHTR1CEatJgFbmQwEBGMpS6vkDbq-NjGUhQFGxMlxSDT34a5JvFF_KuXVmwqfhxgskr3hTsxJ8xZQTI7a_PAQIZxd9eOJCpJn--mwoMAGbMWdEFUNC0R76RafVKMMe6KTzgKpWFUNm9gD4g4gpbivTixs-kyOiWD0HTfVgf515G_3aFgEueygZZo-DX_QMdCoqWpbFh6jU_Hdvm_nYHwKayXq9XHpyrc9G-YAgs-0AHA','eyJraWQiOiJhdXRoLmF0bGFzc2lhbi5jb20tUkVGUkVTSC0yNmE1MTFiMS05NmZmLTQwOWEtYTFhMC1lOGQyMzQ3OGFiYTkiLCJhbGciOiJSUzI1NiJ9.eyJqdGkiOiI3MTc5ZDc4Zi1hYWIyLTQ5ODAtODU4My04ZjZhZjhjMmFlYmUiLCJzdWIiOiI3MTIwMjA6M2MwNWYzMTgtZTc3MC00MTA1LWE0NjktOWU5Y2VhY2Q5ZTlhIiwibmJmIjoxNzE2MTExNTcxLCJpc3MiOiJodHRwczovL2F1dGguYXRsYXNzaWFuLmNvbSIsImlhdCI6MTcxNjExMTU3MSwiZXhwIjoxNzIzODg3NTcxLCJhdWQiOiJYcjc2NTNjMktST2h0clhkelJ4aFNRODZwa3hBZzRQSCIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS9hdGxfdG9rZW5fdHlwZSI6IlJPVEFUSU5HX1JFRlJFU0giLCJ2ZXJpZmllZCI6InRydWUiLCJodHRwczovL2lkLmF0bGFzc2lhbi5jb20vc2Vzc2lvbl9pZCI6ImQxZWFjMjcyLTM4ZDQtNDRmYi04NjNkLWNmNTI4NjQ4NDQzYyIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS9wcm9jZXNzUmVnaW9uIjoidXMtd2VzdC0yIiwiaHR0cHM6Ly9pZC5hdGxhc3NpYW4uY29tL3BhcmVudF9hY2Nlc3NfdG9rZW5faWQiOiI0MDc5Njc0NS0zY2M4LTQ2ZTktYmQwMi05OTJiZjg5MTBiYTYiLCJodHRwczovL2lkLmF0bGFzc2lhbi5jb20vdWp0IjoiNWFiZDVmNDItNzE4Ni00ODM3LTg5OWUtZTIyNTUzNWNjYmVlIiwiaHR0cHM6Ly9pZC5hdGxhc3NpYW4uY29tL3ZlcmlmaWVkIjp0cnVlLCJzY29wZSI6InJlYWQ6amlyYS13b3JrIG9mZmxpbmVfYWNjZXNzIHdyaXRlOmppcmEtd29yayByZWFkOmppcmEtdXNlciIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS9yZWZyZXNoX2NoYWluX2lkIjoiWHI3NjUzYzJLUk9odHJYZHpSeGhTUTg2cGt4QWc0UEgtNzEyMDIwOjNjMDVmMzE4LWU3NzAtNDEwNS1hNDY5LTllOWNlYWNkOWU5YS1kODcyNjkwOS0yYmM5LTQzYTItODY3Yy0zOGUwNWEzMGNhODcifQ.lfaBvLy8ghUx75Apxoww5E35c0CqojKB8YT8Y3eysBm5U7bCuorfFdVyt72SE-i-nKGB4OduApdmjnuXBmOFIo8ct-zhbujeDLMv7qhKZsTzREiLdmNR4pIoZRlYOjrniM_UCsms2nbpZZVGzeK1w68kfzvpQtQuWhgbbSx4TWoqTQBWBKVqjJWMCFQ7S_7AvYkZWbQmjsAVH4liXFuXKoWOGNJO4gfXLsNA_-j4UQVB3zDZV7t-EMO7SVwtnVQxhz0j4uY4LR1SouLzdPe0hrmO1gKRea1elMPkVaqOWr2yGCPi2mIRKk6b9N7V43evrOTaHPiEtlWO0hk_CQLfnA','2024-05-19 10:39:33','2024-05-19 09:39:33','2024-05-19 09:39:33'),(2,'1052881','15a21def-11f5-4358-ab48-074194685963','hsj990604@gmail.com','eyJraWQiOiJhdXRoLmF0bGFzc2lhbi5jb20tQUNDRVNTLWE5Njg0YTZlLTY4MjctNGQ1Yi05MzhjLWJkOTZjYzBiOTk0ZCIsImFsZyI6IlJTMjU2In0.eyJqdGkiOiI5NTQ5OGYwYi0zZTk5LTRiNjItOTIxNi1iNjA5NjRkMzc2NTYiLCJzdWIiOiI3MTIwMjA6NzllZmU1Y2EtYTU4NS00MzQ2LWI4ZWItMTQ0NWFlODdjY2FhIiwibmJmIjoxNzE2MTgwNzkyLCJpc3MiOiJodHRwczovL2F1dGguYXRsYXNzaWFuLmNvbSIsImlhdCI6MTcxNjE4MDc5MiwiZXhwIjoxNzE2MTg0MzkyLCJhdWQiOiJYcjc2NTNjMktST2h0clhkelJ4aFNRODZwa3hBZzRQSCIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS9ydGkiOiJjNTgxNDUyNy0wMGE2LTQ0N2ItYTM0YS0wOThmOTc0ZjVkOGQiLCJodHRwczovL2lkLmF0bGFzc2lhbi5jb20vcmVmcmVzaF9jaGFpbl9pZCI6IlhyNzY1M2MyS1JPaHRyWGR6UnhoU1E4NnBreEFnNFBILTcxMjAyMDo3OWVmZTVjYS1hNTg1LTQzNDYtYjhlYi0xNDQ1YWU4N2NjYWEtNjVmMDM3ODMtYTExMi00YWI3LWFkMGUtYzE3NTA5NGZjZGMwIiwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tL3N5c3RlbUFjY291bnRFbWFpbCI6IjY0Mzc1MDg3LWQwZDItNGJmOC1hNjNjLWMzMDdmNjAyZTBkYUBjb25uZWN0LmF0bGFzc2lhbi5jb20iLCJodHRwczovL2lkLmF0bGFzc2lhbi5jb20vYXRsX3Rva2VuX3R5cGUiOiJBQ0NFU1MiLCJodHRwczovL2F0bGFzc2lhbi5jb20vZmlyc3RQYXJ0eSI6ZmFsc2UsImh0dHBzOi8vYXRsYXNzaWFuLmNvbS92ZXJpZmllZCI6dHJ1ZSwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tL29hdXRoQ2xpZW50SWQiOiJYcjc2NTNjMktST2h0clhkelJ4aFNRODZwa3hBZzRQSCIsInZlcmlmaWVkIjoidHJ1ZSIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS9wcm9jZXNzUmVnaW9uIjoidXMtd2VzdC0yIiwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tL2VtYWlsRG9tYWluIjoiZ21haWwuY29tIiwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tLzNsbyI6dHJ1ZSwiaHR0cHM6Ly9pZC5hdGxhc3NpYW4uY29tL3VqdCI6IjgyYWYzNWZmLTI3YjUtNGE1NS04ZDc3LTExNDhmZWRjYjdmMyIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS92ZXJpZmllZCI6dHJ1ZSwiaHR0cHM6Ly9pZC5hdGxhc3NpYW4uY29tL3Nlc3Npb25faWQiOiIwZjEzOTcyNC05Njg1LTQwMTQtYjVkMC05MDM3ZGUxOTVhMjkiLCJjbGllbnRfaWQiOiJYcjc2NTNjMktST2h0clhkelJ4aFNRODZwa3hBZzRQSCIsInNjb3BlIjoib2ZmbGluZV9hY2Nlc3MgcmVhZDpqaXJhLXVzZXIgcmVhZDpqaXJhLXdvcmsgd3JpdGU6amlyYS13b3JrIiwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tL3N5c3RlbUFjY291bnRFbWFpbERvbWFpbiI6ImNvbm5lY3QuYXRsYXNzaWFuLmNvbSIsImh0dHBzOi8vYXRsYXNzaWFuLmNvbS9zeXN0ZW1BY2NvdW50SWQiOiI3MTIwMjA6ZmM4YjhjYjgtYWU5YS00ZjFjLWE2ZjItMjNkMjEzZjc0OGMzIn0.Y2kLzpco0nLuon3rjs2K8uDM0fk_VlcXYRU-7ohoHbJjYq9sEL7rUfAa5LFR6Tij2feCRRkkRxLXGHqsxz6UTKJToYwaa9ZecEjz4mc-Dn_nlbcLa97O31KI9LdG3PcFkldf6HAOxkR_d6jLplqYf4LKF9lfHilSIFQN5uSvErbZKIvp0UTVXqQIfyt7Of20cK79zy9IAOhXvsnMy1rGCBP2E5Xvn5oSvIskqeJ8dlATa8EXQd5F7BNp6tbfh-RipMZm26jpu_Tv7Sd-ZVYHcgdT_WIM7G76eW7dr91sj9fAa7XVW17PR446Bc4gOEl5ejmosOq6XXje5bdvsvyItA','eyJraWQiOiJhdXRoLmF0bGFzc2lhbi5jb20tUkVGUkVTSC0yNmE1MTFiMS05NmZmLTQwOWEtYTFhMC1lOGQyMzQ3OGFiYTkiLCJhbGciOiJSUzI1NiJ9.eyJqdGkiOiJjNTgxNDUyNy0wMGE2LTQ0N2ItYTM0YS0wOThmOTc0ZjVkOGQiLCJzdWIiOiI3MTIwMjA6NzllZmU1Y2EtYTU4NS00MzQ2LWI4ZWItMTQ0NWFlODdjY2FhIiwibmJmIjoxNzE2MTgwNzkyLCJpc3MiOiJodHRwczovL2F1dGguYXRsYXNzaWFuLmNvbSIsImlhdCI6MTcxNjE4MDc5MiwiZXhwIjoxNzIzOTU2NzkyLCJhdWQiOiJYcjc2NTNjMktST2h0clhkelJ4aFNRODZwa3hBZzRQSCIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS9hdGxfdG9rZW5fdHlwZSI6IlJPVEFUSU5HX1JFRlJFU0giLCJ2ZXJpZmllZCI6InRydWUiLCJodHRwczovL2lkLmF0bGFzc2lhbi5jb20vcGFyZW50X2FjY2Vzc190b2tlbl9pZCI6Ijk1NDk4ZjBiLTNlOTktNGI2Mi05MjE2LWI2MDk2NGQzNzY1NiIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS9wcm9jZXNzUmVnaW9uIjoidXMtd2VzdC0yIiwiaHR0cHM6Ly9pZC5hdGxhc3NpYW4uY29tL3JlZnJlc2hfY2hhaW5faWQiOiJYcjc2NTNjMktST2h0clhkelJ4aFNRODZwa3hBZzRQSC03MTIwMjA6NzllZmU1Y2EtYTU4NS00MzQ2LWI4ZWItMTQ0NWFlODdjY2FhLTY1ZjAzNzgzLWExMTItNGFiNy1hZDBlLWMxNzUwOTRmY2RjMCIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS92ZXJpZmllZCI6dHJ1ZSwiaHR0cHM6Ly9pZC5hdGxhc3NpYW4uY29tL3VqdCI6IjgyYWYzNWZmLTI3YjUtNGE1NS04ZDc3LTExNDhmZWRjYjdmMyIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS9zZXNzaW9uX2lkIjoiMGYxMzk3MjQtOTY4NS00MDE0LWI1ZDAtOTAzN2RlMTk1YTI5Iiwic2NvcGUiOiJvZmZsaW5lX2FjY2VzcyByZWFkOmppcmEtdXNlciByZWFkOmppcmEtd29yayB3cml0ZTpqaXJhLXdvcmsifQ.GxLm0JM6uUg1BCN5hbAxWyI63Sfq0jLR8cWQV8f-pon3K2ExZwBV4IBIWxjsgyOsqbJhraM2bvuMc1Ei74dTmAMz9ttO5peG-w_gofhVIX3RsSbrPRdmRjwYq5DQxQtYIZU3W98Lp2Ral1b-ALY_x6L--WLpCRryv-IAlFhm5kxBrslrXra6VMW0A2Xj2iI1450rmuGDWwCVNxniXiEnNIax2r1CohA95exC7CL0zPu5hfTVu8gGS-nSQgPSA-IPWLC5ZsV3nEyBFk5nNFGp2aoeNqpim5vF8RoJPEhOOeaR-F6xZ1pIfTnJLtGYESB-5g2iPxn5SOP0D5jR2ONbAg','2024-05-19 20:53:12','2024-05-20 04:53:12','2024-05-20 04:53:12'),(3,'1058706','15a21def-11f5-4358-ab48-074194685963','diduedidue@naver.com','eyJraWQiOiJhdXRoLmF0bGFzc2lhbi5jb20tQUNDRVNTLWE5Njg0YTZlLTY4MjctNGQ1Yi05MzhjLWJkOTZjYzBiOTk0ZCIsImFsZyI6IlJTMjU2In0.eyJqdGkiOiIxZGQ5YTE4MC0zODg3LTRiMGQtOTUxZi1hMzRmY2VmY2E5ZmQiLCJzdWIiOiI3MTIwMjA6YTMxMWIxM2MtN2Y4MC00MTUxLTgxMTAtYzRjMzAwYTZlODlmIiwibmJmIjoxNzE2MTUxMjM5LCJpc3MiOiJodHRwczovL2F1dGguYXRsYXNzaWFuLmNvbSIsImlhdCI6MTcxNjE1MTIzOSwiZXhwIjoxNzE2MTU0ODM5LCJhdWQiOiJYcjc2NTNjMktST2h0clhkelJ4aFNRODZwa3hBZzRQSCIsImh0dHBzOi8vYXRsYXNzaWFuLmNvbS9zeXN0ZW1BY2NvdW50RW1haWwiOiI2NDM3NTA4Ny1kMGQyLTRiZjgtYTYzYy1jMzA3ZjYwMmUwZGFAY29ubmVjdC5hdGxhc3NpYW4uY29tIiwiaHR0cHM6Ly9pZC5hdGxhc3NpYW4uY29tL2F0bF90b2tlbl90eXBlIjoiQUNDRVNTIiwiaHR0cHM6Ly9pZC5hdGxhc3NpYW4uY29tL3JlZnJlc2hfY2hhaW5faWQiOiJYcjc2NTNjMktST2h0clhkelJ4aFNRODZwa3hBZzRQSC03MTIwMjA6YTMxMWIxM2MtN2Y4MC00MTUxLTgxMTAtYzRjMzAwYTZlODlmLTMyZGNiM2I4LTAwOWMtNDkzYi1hZTViLWI2NjIxNzlhNDNiMCIsImh0dHBzOi8vYXRsYXNzaWFuLmNvbS9maXJzdFBhcnR5IjpmYWxzZSwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tL3ZlcmlmaWVkIjp0cnVlLCJodHRwczovL2F0bGFzc2lhbi5jb20vb2F1dGhDbGllbnRJZCI6IlhyNzY1M2MyS1JPaHRyWGR6UnhoU1E4NnBreEFnNFBIIiwidmVyaWZpZWQiOiJ0cnVlIiwiaHR0cHM6Ly9pZC5hdGxhc3NpYW4uY29tL3Byb2Nlc3NSZWdpb24iOiJ1cy13ZXN0LTIiLCJodHRwczovL2F0bGFzc2lhbi5jb20vZW1haWxEb21haW4iOiJuYXZlci5jb20iLCJodHRwczovL2lkLmF0bGFzc2lhbi5jb20vcnRpIjoiY2Y5YTk0NzctMmUwYy00MGZmLTgyNTQtMjk3MzY3NWY0Y2E2IiwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tLzNsbyI6dHJ1ZSwiaHR0cHM6Ly9pZC5hdGxhc3NpYW4uY29tL3Nlc3Npb25faWQiOiIwNTIyODM5Zi01MTA2LTQyNzktOWViNi0wMjVjMjAxM2E5MmIiLCJodHRwczovL2lkLmF0bGFzc2lhbi5jb20vdWp0IjoiM2FlZjI0ZWYtNjkwNi00MzExLTgzOTQtMGUxYjYxZDFiMjA1IiwiaHR0cHM6Ly9pZC5hdGxhc3NpYW4uY29tL3ZlcmlmaWVkIjp0cnVlLCJjbGllbnRfaWQiOiJYcjc2NTNjMktST2h0clhkelJ4aFNRODZwa3hBZzRQSCIsInNjb3BlIjoib2ZmbGluZV9hY2Nlc3MgcmVhZDpqaXJhLXVzZXIgcmVhZDpqaXJhLXdvcmsgd3JpdGU6amlyYS13b3JrIiwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tL3N5c3RlbUFjY291bnRFbWFpbERvbWFpbiI6ImNvbm5lY3QuYXRsYXNzaWFuLmNvbSIsImh0dHBzOi8vYXRsYXNzaWFuLmNvbS9zeXN0ZW1BY2NvdW50SWQiOiI3MTIwMjA6ZmM4YjhjYjgtYWU5YS00ZjFjLWE2ZjItMjNkMjEzZjc0OGMzIn0.0hsEKpI6Unu_OjiWhHTbW3yccJENB7A1HIprf2ucGlKd_YnzaqmMAjUO9JKDmrtfrTXZ8Kc0IGDM-QE8ME3jI9Me7YUErRmuE36tUC5hJJJuis6C8yxa6gD4X-fDk2UWYe8kiS1r2DK5R_Kp3XxwDBnyxRLQ1SAXNH2GNH-kqs9HEG__2YfQ1KhQMm33p6-0pxOKE5WjDzIVn5uqgx6l_L3-8-CcZ8ghMO-3clq5d1RfEudC1LPm1JyREQx7pHfHxvyx_yb7ua-Rbv8ie4hSP5Cxzci0fxM9t1vofnB8hMhLA_KkV7nqp29E0Rx05lXSObYoNFzsp9MGF7JajBLYqw','eyJraWQiOiJhdXRoLmF0bGFzc2lhbi5jb20tUkVGUkVTSC0yNmE1MTFiMS05NmZmLTQwOWEtYTFhMC1lOGQyMzQ3OGFiYTkiLCJhbGciOiJSUzI1NiJ9.eyJqdGkiOiJjZjlhOTQ3Ny0yZTBjLTQwZmYtODI1NC0yOTczNjc1ZjRjYTYiLCJzdWIiOiI3MTIwMjA6YTMxMWIxM2MtN2Y4MC00MTUxLTgxMTAtYzRjMzAwYTZlODlmIiwibmJmIjoxNzE2MTUxMjM5LCJpc3MiOiJodHRwczovL2F1dGguYXRsYXNzaWFuLmNvbSIsImlhdCI6MTcxNjE1MTIzOSwiZXhwIjoxNzIzOTI3MjM5LCJhdWQiOiJYcjc2NTNjMktST2h0clhkelJ4aFNRODZwa3hBZzRQSCIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS9hdGxfdG9rZW5fdHlwZSI6IlJPVEFUSU5HX1JFRlJFU0giLCJ2ZXJpZmllZCI6InRydWUiLCJodHRwczovL2lkLmF0bGFzc2lhbi5jb20vcGFyZW50X2FjY2Vzc190b2tlbl9pZCI6IjFkZDlhMTgwLTM4ODctNGIwZC05NTFmLWEzNGZjZWZjYTlmZCIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS9wcm9jZXNzUmVnaW9uIjoidXMtd2VzdC0yIiwiaHR0cHM6Ly9pZC5hdGxhc3NpYW4uY29tL3VqdCI6IjNhZWYyNGVmLTY5MDYtNDMxMS04Mzk0LTBlMWI2MWQxYjIwNSIsImh0dHBzOi8vaWQuYXRsYXNzaWFuLmNvbS9zZXNzaW9uX2lkIjoiMDUyMjgzOWYtNTEwNi00Mjc5LTllYjYtMDI1YzIwMTNhOTJiIiwiaHR0cHM6Ly9pZC5hdGxhc3NpYW4uY29tL3ZlcmlmaWVkIjp0cnVlLCJodHRwczovL2lkLmF0bGFzc2lhbi5jb20vcmVmcmVzaF9jaGFpbl9pZCI6IlhyNzY1M2MyS1JPaHRyWGR6UnhoU1E4NnBreEFnNFBILTcxMjAyMDphMzExYjEzYy03ZjgwLTQxNTEtODExMC1jNGMzMDBhNmU4OWYtMzJkY2IzYjgtMDA5Yy00OTNiLWFlNWItYjY2MjE3OWE0M2IwIiwic2NvcGUiOiJvZmZsaW5lX2FjY2VzcyByZWFkOmppcmEtdXNlciByZWFkOmppcmEtd29yayB3cml0ZTpqaXJhLXdvcmsifQ.X3eS4ry0EplL7IUjZqsQ93oo5yhmmBsb0TeaqgSqXVRZoQyPV7G8xVlH8yBp1FcyPHiRU-hqbGNZ7gcci5K7UDn7cOZqIPnJDblu1oCt0La8PqVIhbxfhgdTTtOBnl0CfnrUnPcLONojDv9SOp1fs7wFj8g1XmngkXKql6sEcBa9Cyx1nN9Zy4iwHAQE1rt8MAtzLeXFZ2WvXR2Niy1_I8w2bqVkI1ogbBEfTX_aRyz4nhoJ3OkpTwKDz4rv_G_qxgyUVnooMvYAKu0nXqO_m88KvMGqrM7P1gUGL1tvCBgd5eeA-5oPZJ7DYU_2XB0h3hQQW6dKhtD6v2ke5tksPQ','2024-05-19 12:40:39','2024-05-19 20:40:39','2024-05-19 20:40:39');
/*!40000 ALTER TABLE `JiraToken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Location`
--

DROP TABLE IF EXISTS `Location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Location` (
  `location_code` varchar(5) NOT NULL,
  `location_name` varchar(40) NOT NULL,
  PRIMARY KEY (`location_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Location`
--

LOCK TABLES `Location` WRITE;
/*!40000 ALTER TABLE `Location` DISABLE KEYS */;
INSERT INTO `Location` VALUES ('A','서울'),('B','대전'),('C','광주'),('D','구미'),('E','부울경'),('Z','테스트');
/*!40000 ALTER TABLE `Location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MMChannel`
--

DROP TABLE IF EXISTS `MMChannel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MMChannel` (
  `mm_channel_id` varchar(40) NOT NULL,
  `mm_channel_name` varchar(40) NOT NULL,
  `mm_team_id` varchar(40) NOT NULL,
  PRIMARY KEY (`mm_channel_id`),
  KEY `FK_MMTeam_TO_MMChannel_1` (`mm_team_id`),
  CONSTRAINT `FK_MMTeam_TO_MMChannel_1` FOREIGN KEY (`mm_team_id`) REFERENCES `MMTeam` (`mm_team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MMChannel`
--

LOCK TABLES `MMChannel` WRITE;
/*!40000 ALTER TABLE `MMChannel` DISABLE KEYS */;
INSERT INTO `MMChannel` VALUES ('14ieycorxbngmc1ymoop5shsdc','soyoung','6hw7x6j39pnczcnkb6ot9x8e6h'),('18w38pqay7gpmn8qdnp3fbc7yo','2조가 이렇게 잘하조','6hw7x6j39pnczcnkb6ot9x8e6h'),('1bkcmtceztfkpcy1n976ze9smh','<팀채널>E105','tt19wwyk9tb13g68ne6oz67e1y'),('1gyhdiugjfgbdns9amt8rw84uc','7. 온라인스터디','6hw7x6j39pnczcnkb6ot9x8e6h'),('1htt7ake1pr8fdw3hqk1rf8yzh','2. 물어봐요(Q&A)','3tu3jzkrnbfsxyf6q9wjiotypc'),('33rgixh36inxmjjoyj1dbnuhsy','7. 모빌리티(스마트홈)','7xfrya3fhbd5peetn8znkxyuke'),('35txonwaptf5myy7yn3mj4xztc','임시1반 4조','6hw7x6j39pnczcnkb6ot9x8e6h'),('3caqfitij3fibfcg9h6eui7zzr','5. [취업] 취업뉴스','6hw7x6j39pnczcnkb6ot9x8e6h'),('3ehq66o1yjn7mc8uggk1885f4r','공지사항','kqjrdx1no3d6fm4r5iobr16o8o'),('3gfmw3ao17d6td95869wqqzego','과제리뷰 일지 제출방','8czq37ysrfg7bmczp8mkbxeney'),('3kcrzjxc4tn1tj5ab4zcpaka9r','잡담','uhrbu15mw7f88m5btnh6u5dwfa'),('3peuqu87sp8nbrkieq6juhbtqh','your','ju7d9qyimb8diyxofoezpmpxuh'),('44c7j9eshfyq7g79ujs8smahyh','4조 화이팅~!','1bk9c48cd7rrt8bawapgehkx9o'),('4hi5hcymyibnjchkcntn8uetty','Keyboard','6hw7x6j39pnczcnkb6ot9x8e6h'),('4jkrge85gjd1z8ptkgp933od1h','1. 주목해요(공지)','3tu3jzkrnbfsxyf6q9wjiotypc'),('4kfg684bmfy1ixran85sipbsch','your bab','ju7d9qyimb8diyxofoezpmpxuh'),('4nnwxrogoifnip6rgmi5t5nbjw','공지사항','kyue9x8ogtf83mawfktqoi1szw'),('57tt5aojz3nrxprqtxi9m1efiw','밥','kqjrdx1no3d6fm4r5iobr16o8o'),('5db8dpgcutyn5mdn8remp344wc','대전의10기임시2반','6hw7x6j39pnczcnkb6ot9x8e6h'),('5jxi8qxdq3yzdnxhzxg5k8fw8h','CS스터디','6hw7x6j39pnczcnkb6ot9x8e6h'),('5k8u6w4sxidwpebeehnchpwubc','DJ JM','6hw7x6j39pnczcnkb6ot9x8e6h'),('63e6prqu9tyn5d6j65j79py5ih','6. 블록체인(NFT)','7xfrya3fhbd5peetn8znkxyuke'),('6h96pn16btrixd5poq4gq6jk7h','특화PJT','6hw7x6j39pnczcnkb6ot9x8e6h'),('6y8tboweetfpfeixr6z7a3xk6e','놀이터','kqjrdx1no3d6fm4r5iobr16o8o'),('6y9bucp8btn1dcxdqgdf7sc83w','공지사항','6ikg9y8nt7f7pctro14eakz7ee'),('7dhgf16r9ignbyriz1e1w1xh5c','10. 핀테크','7xfrya3fhbd5peetn8znkxyuke'),('7pkrayw55ffjpewpt77xpda6hc','lolman','6hw7x6j39pnczcnkb6ot9x8e6h'),('7xkqnoqqkfgtm8pez9gx117mkw','4. 온/오프라인코칭','n8qdcw7ex7bypmy8q796qkahma'),('81bggbgfj3ntfeaajcpijb6daw','임시1반출신','6hw7x6j39pnczcnkb6ot9x8e6h'),('8chgdx53ejywmndsdkf93o84jh','잡담','7xfrya3fhbd5peetn8znkxyuke'),('8cm3h9we578oie784o9zed7kto','3. 행사/이벤트','n8qdcw7ex7bypmy8q796qkahma'),('94dk3rb1f3b558bu7wcg6yrc7r','.','wqtsgsymt3fh8rsxr53bunj68c'),('98fs3fikxprc8xhkrdyjf66pow','서울캠퍼스 오늘의점심','6hw7x6j39pnczcnkb6ot9x8e6h'),('99gq3jqyn3nu7r35zmpkmpt5tc','team7Backend','6hw7x6j39pnczcnkb6ot9x8e6h'),('9z4fkkb99bbpiq3i61eepyrwsr','구미캠퍼스 오늘의점심','6hw7x6j39pnczcnkb6ot9x8e6h'),('apssjiakapftjrjh96ojw6cb4r','잡담','kqjrdx1no3d6fm4r5iobr16o8o'),('ar1kyjoma7gnfcjxxsi4ag5bdr','팀빌딩','1bk9c48cd7rrt8bawapgehkx9o'),('bcrp5iqj8fby9r78pdkfaj4nuw','3. 참여해요(이벤트)','3tu3jzkrnbfsxyf6q9wjiotypc'),('bcxshg7p738z9b9or5brw6pwdc','자기소개(장표 공유)','8czq37ysrfg7bmczp8mkbxeney'),('bga3h3kjufgrmx3hpbneqhk1gr','자치회 공지방','6hw7x6j39pnczcnkb6ot9x8e6h'),('bgg7gedd7pbxmcpymk6dag68sy','잡담','8czq37ysrfg7bmczp8mkbxeney'),('buo3hzjfc7nfzrroocddrmy7ge','테스트채널23','6hw7x6j39pnczcnkb6ot9x8e6h'),('bznuggx1rinr9bmrf9rqbx6k6o','공지사항','tt19wwyk9tb13g68ne6oz67e1y'),('c36ixaqbqffr3cg8f3155sww5h','Onboarding Run','6hw7x6j39pnczcnkb6ot9x8e6h'),('cdgkd45fpidkjbx7qeffbnbf7a','싸피레이스_광주3반_강승원_주홍찬_황유경','3tu3jzkrnbfsxyf6q9wjiotypc'),('cozs5fzm8fg4mmr9i3cruakmmr','3. 학습','6hw7x6j39pnczcnkb6ot9x8e6h'),('dkusc1651jdpuf49txdxqw7jbe','대전캠퍼스 오늘의점심','6hw7x6j39pnczcnkb6ot9x8e6h'),('dqjwj5cgwprbdy7yta1y3gtkec','3. 행사/이벤트','ju7d9qyimb8diyxofoezpmpxuh'),('dyn8qnsxqtr85j36z4kokrdc6h','공통 E104팀 GitLab','6hw7x6j39pnczcnkb6ot9x8e6h'),('e1isrpokjp8qm871symes5a74e','2. 소통','6hw7x6j39pnczcnkb6ot9x8e6h'),('e951ogrz4jys3y34ong3e8jsfo','(임직원 멘토링)','6hw7x6j39pnczcnkb6ot9x8e6h'),('epptyp8hoinqinfx3x75tdyzcy','2. 소통','n8qdcw7ex7bypmy8q796qkahma'),('ewofw1t5rb85my5bbcrkhkwpeh','취업 관련','1bk9c48cd7rrt8bawapgehkx9o'),('eyhi6cw6etbqp8r1it397wc1cc','8. 모빌리티(자율주행)','7xfrya3fhbd5peetn8znkxyuke'),('f4ihatc7r7f15qhgtkqmjmgkye','babjuseyong','tt19wwyk9tb13g68ne6oz67e1y'),('fe8mye3dgt8ntn5bd9qmherauo','공지사항','uhrbu15mw7f88m5btnh6u5dwfa'),('ff8jt56iot8c9dh7bczjmtuj8y','공지사항','7xfrya3fhbd5peetn8znkxyuke'),('fphw98dajtb7peojek4wge6mjh','10기 일타싸피','n8qdcw7ex7bypmy8q796qkahma'),('g1utp9pm73g45n9aowdp67dmno','bot','n8qdcw7ex7bypmy8q796qkahma'),('gabwf33sqt8kbmbmis1cz8oq9e','잡담','6ikg9y8nt7f7pctro14eakz7ee'),('gcce41u3mjgg8kunepr5fs838h','6. 오늘의 추천곡','ju7d9qyimb8diyxofoezpmpxuh'),('gcpyikxnof8ejmt1pukebraauy','9. 메타버스 게임','7xfrya3fhbd5peetn8znkxyuke'),('gtbpbrfbqffabenzc9pmzi576e','부울경캠퍼스 오늘의점심','6hw7x6j39pnczcnkb6ot9x8e6h'),('h6hsbq3bybnepnfgnetynd6msh','서울임시6반4조','6hw7x6j39pnczcnkb6ot9x8e6h'),('hewwzmwbytrm5gpg9tdb3ntj9c','TEMP','6hw7x6j39pnczcnkb6ot9x8e6h'),('hk3oayy5xif6fr5ut8y18j63or','어둠의 프론트엔드 소모임','6hw7x6j39pnczcnkb6ot9x8e6h'),('ia577uta3p8a9ypqwz9c4a1kro','모아스 공지방','kqjrdx1no3d6fm4r5iobr16o8o'),('iccosikuxjbh3pg54ua8petiwe','공지사항','gbyjy7ms37d7tywiouhw55bqny'),('iukmiyeszjgwm8zwc8jgchzofe','bab','1bk9c48cd7rrt8bawapgehkx9o'),('iyh4n79ywtb1ff7jwhkyzprdko','특화','6hw7x6j39pnczcnkb6ot9x8e6h'),('j4rjg5riopdixpky4pdhzztrrr','잘못만들었으니까 관리자님 빨리 지워주세요','6hw7x6j39pnczcnkb6ot9x8e6h'),('j913d4o6g7b9uddrtecwodpstr','임시2반 5조','6hw7x6j39pnczcnkb6ot9x8e6h'),('jcbfupmoeigx5xc6y5tdqghkny','팀빌딩','tt19wwyk9tb13g68ne6oz67e1y'),('jzj5o54szpbkjc9n1t6wf8xrar','공지사항','1bk9c48cd7rrt8bawapgehkx9o'),('jzyngsajgj8p9p9xjjnpra6w9y','bab','gbyjy7ms37d7tywiouhw55bqny'),('ko4cuiaox3rjbbry85k7tswp5r','잡담','tt19wwyk9tb13g68ne6oz67e1y'),('kziuz1x8digw9ncpn43ymucdsc','3. 빅데이터(추천)','7xfrya3fhbd5peetn8znkxyuke'),('muh5russsifbxgrz33jenqtc5w','자율 공지방','kqjrdx1no3d6fm4r5iobr16o8o'),('mz3bzes9qfg7ixkcbpsw3j5f7r','1월 13일 롤','ju7d9qyimb8diyxofoezpmpxuh'),('nhdgqk3t93r1tdhdn9hb5tpbky','공지사항','kqjrdx1no3d6fm4r5iobr16o8o'),('nio5uqzhepghmn6xh3uqyjg6sy','어둠의 백엔드 소모임','6hw7x6j39pnczcnkb6ot9x8e6h'),('nwd3p3w3hbbn7crb1r4h3guqea','SSAFY ALGORITHM GROUP','6hw7x6j39pnczcnkb6ot9x8e6h'),('nyqram1c9bfqppj8pb9n5pk3uy','1. 공지사항','nc61uqhaniffifmdkd6maunpro'),('oaow4tkuj3gypd9u3uh851ah1h','10기 모듈형 특강_특화PM 3조','6hw7x6j39pnczcnkb6ot9x8e6h'),('od9gz1d8ytnmjbdiebhnupq13a','크리에이터챌린지 임시17반_5조','6hw7x6j39pnczcnkb6ot9x8e6h'),('oeepqxbum78qtj7369p8mo6wha','아이디어톤 1반 3조','6hw7x6j39pnczcnkb6ot9x8e6h'),('okjq5twa97rkdxs74edsk5ppwa','2. 소통','ju7d9qyimb8diyxofoezpmpxuh'),('op64qcd6wfyb5b6zomj8kij8pe','4. 온/오프라인코칭','ju7d9qyimb8diyxofoezpmpxuh'),('os31hob6bjfbued9m6915ey8eo','24년 3차 멘토링 간담회(시온아빠)','6hw7x6j39pnczcnkb6ot9x8e6h'),('p48pzyx867rkubzwkfxacd4quo','공지사항','f9j5qbm6djy17enbeyaqeyh81a'),('puwipjbt7bygjfbgjkpr1nzx9w','E203 공지방1','kqjrdx1no3d6fm4r5iobr16o8o'),('pz7fdt6iffgetc87duatc91fxo','잡담','nc61uqhaniffifmdkd6maunpro'),('pzn91xoso3ga3fn3rrad1tsr7y','4. 빅데이터(분산)','7xfrya3fhbd5peetn8znkxyuke'),('qek45jiqkpdnddkbxdpym4gc5o','잡담','f9j5qbm6djy17enbeyaqeyh81a'),('qhnydpq5afnbm86yo77wmwk3oc','1. 공지사항','n8qdcw7ex7bypmy8q796qkahma'),('qnn4ke9qdjbe38toc63xksyrdr','코딩잘안될때소리지르는채널','6hw7x6j39pnczcnkb6ot9x8e6h'),('rj4on19gaigo7pqoytk1dmwcxe','공지사항','wqtsgsymt3fh8rsxr53bunj68c'),('rk3krmfxi38r3q4zij43wuqnah','5. 블록체인(P2P)','7xfrya3fhbd5peetn8znkxyuke'),('rxz1tjpt9ibq8rbo8zxcz3rqwo','10기 일타싸피','ju7d9qyimb8diyxofoezpmpxuh'),('s3ks9fj4838q7kp3dkw69azwoy','오늘의 점심','7xfrya3fhbd5peetn8znkxyuke'),('sbm39efpkpfxzdwk4irpzm4seo','광주캠퍼스 오늘의점심','6hw7x6j39pnczcnkb6ot9x8e6h'),('sebqko7bfbdfpm41n9kctzknae','bobjusaeyong','tt19wwyk9tb13g68ne6oz67e1y'),('seoo7qhxrin5imnwp4gwt7umke','공지사항','8czq37ysrfg7bmczp8mkbxeney'),('siuogi495bddmjh4jmip9183ar','CS스터디','6hw7x6j39pnczcnkb6ot9x8e6h'),('spwxb1hb73bmbct3e556u4ye5e','대전임시3반','6hw7x6j39pnczcnkb6ot9x8e6h'),('ssh7te9dyind7bxs1hnrpjjo4r','yaenajolBackend','6hw7x6j39pnczcnkb6ot9x8e6h'),('std89j8j5fgszkn73956geayna','1. 인공지능(영상)','7xfrya3fhbd5peetn8znkxyuke'),('tjuoabn857dqfpmafkqntr3q3r','[Seoul] Back-End','6hw7x6j39pnczcnkb6ot9x8e6h'),('tre5ge5owiyu3jn6iwsro176ma','24년 3차 멘토링 간담회(시온아빠)','6hw7x6j39pnczcnkb6ot9x8e6h'),('twhtbqcm3t8tjy3ruxo94exedw','2. 인공지능(음성)','7xfrya3fhbd5peetn8znkxyuke'),('tys3hjt6s3dr8bw1q4rksbznkr','아맞다지라','kqjrdx1no3d6fm4r5iobr16o8o'),('uad9zwgo5t8gzrub9xjqmmmair','잡담','wqtsgsymt3fh8rsxr53bunj68c'),('ubghdkgs6pnedbaxbcyrambs1r','wealgo','6hw7x6j39pnczcnkb6ot9x8e6h'),('ui5t6psjzifr3m1z1pmrdqqk3h','4. 소통해요(수다방)','3tu3jzkrnbfsxyf6q9wjiotypc'),('ut4b16f8mjrctp5tzab7bym78a','[서울] 프론트엔드 스터디','6hw7x6j39pnczcnkb6ot9x8e6h'),('uwhieanpxj8mue45s3ztmwscmo','잡담','1bk9c48cd7rrt8bawapgehkx9o'),('wbwr7yzegt84tk3ftp759sdp3w','밥주세용','tt19wwyk9tb13g68ne6oz67e1y'),('wgajd8urmibnbr99be4mokaf5y','서울임시6반_1조_크리에이티 챌린지','6hw7x6j39pnczcnkb6ot9x8e6h'),('wwym3b1q5frc5xo8cobtmhkfca','1. 공지사항','6hw7x6j39pnczcnkb6ot9x8e6h'),('wzuoqc977pnhzydzs5t8qc8hkw','4. 발표회 이벤트','6hw7x6j39pnczcnkb6ot9x8e6h'),('x1ucdx8xifd5d8ts6d7j4ghdar','수학석사 석지명 팬카페','6hw7x6j39pnczcnkb6ot9x8e6h'),('xaqoq19jm3r5mc5rsqjxkju9xo','어둠의루피단','6hw7x6j39pnczcnkb6ot9x8e6h'),('xaxu6kof6fgkfbam8i5utpx1re','6. [취업] 취업공고','6hw7x6j39pnczcnkb6ot9x8e6h'),('y7hp1g1aw7nqf8yjbyw3tnsxra','아이디어톤','6hw7x6j39pnczcnkb6ot9x8e6h'),('yq8937shwbd1fmesbdn3n95tsa','code','ju7d9qyimb8diyxofoezpmpxuh'),('yrya4y3nabgtuduoyn6he64q3h','싸피레이스 광주3반 강승원_황유경_주홍찬','6hw7x6j39pnczcnkb6ot9x8e6h'),('z5p5jtgjmbf5mn7tawxh4k4wra','5/14 7시 멘토링간담회','6hw7x6j39pnczcnkb6ot9x8e6h'),('zc4t4abfwjgt3kkwrmj9qs8m3o','1. 공지사항','ju7d9qyimb8diyxofoezpmpxuh'),('zgdbtw44gfr1bbktwqbpae99bc','잡담','gbyjy7ms37d7tywiouhw55bqny'),('zgq1mdqsxbnmpdgu9uyhz3cp7w','임시7반_2조','6hw7x6j39pnczcnkb6ot9x8e6h'),('zgueth8kijrb9k5yw9y7wrrspr','잡담','kyue9x8ogtf83mawfktqoi1szw'),('zsqy16fgyt8q5qam66gc43bimy','.','kqjrdx1no3d6fm4r5iobr16o8o');
/*!40000 ALTER TABLE `MMChannel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MMTeam`
--

DROP TABLE IF EXISTS `MMTeam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MMTeam` (
  `mm_team_id` varchar(40) NOT NULL,
  `mm_team_name` varchar(40) NOT NULL,
  `mm_team_icon` varchar(100) NOT NULL,
  PRIMARY KEY (`mm_team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MMTeam`
--

LOCK TABLES `MMTeam` WRITE;
/*!40000 ALTER TABLE `MMTeam` DISABLE KEYS */;
INSERT INTO `MMTeam` VALUES ('1bk9c48cd7rrt8bawapgehkx9o','10기 공통 부울경2반','https://moassbucket.s3.ap-northeast-2.amazonaws.com/3ac9caeb-d9a0-d2e4-f3ce-45f01082f2bd.png'),('3tu3jzkrnbfsxyf6q9wjiotypc','10기 싸피레이스','https://moassbucket.s3.ap-northeast-2.amazonaws.com/a22f0ef3-f539-39a3-3cd5-70ce8c3c1bd1.png'),('6hw7x6j39pnczcnkb6ot9x8e6h','10기 공지 전용','https://moassbucket.s3.ap-northeast-2.amazonaws.com/fb22238a-b5e4-9340-6fde-80cdf76addc5.png'),('6ikg9y8nt7f7pctro14eakz7ee','SW역량테스트',''),('7xfrya3fhbd5peetn8znkxyuke','10기 부울경캠퍼스',''),('8czq37ysrfg7bmczp8mkbxeney','10기 삼성전자 연계 PJT','https://moassbucket.s3.ap-northeast-2.amazonaws.com/92df4c55-c4d7-d850-2dbb-2077f67fbe14.png'),('f9j5qbm6djy17enbeyaqeyh81a','10기 삼성전자 연계 PJT(멘토)','https://moassbucket.s3.ap-northeast-2.amazonaws.com/35f3724a-f0d1-bfc9-29a0-d6c3d3c59152.png'),('gbyjy7ms37d7tywiouhw55bqny','10기 특화 부울경1반','https://moassbucket.s3.ap-northeast-2.amazonaws.com/90f54f2a-afae-fde2-fd71-a59c74c54843.png'),('ju7d9qyimb8diyxofoezpmpxuh','10기 부울경2반','https://moassbucket.s3.ap-northeast-2.amazonaws.com/c638b0a6-1917-cfd3-41e6-a003878ad127.png'),('kqjrdx1no3d6fm4r5iobr16o8o','10기 자율 부울경2반','https://moassbucket.s3.ap-northeast-2.amazonaws.com/e6a8013f-047b-9b38-b865-67b9dc145ad9.png'),('kyue9x8ogtf83mawfktqoi1szw','9기 특화 모빌리티','https://moassbucket.s3.ap-northeast-2.amazonaws.com/005e9bf2-a1e1-c008-1348-11afddf68615.png'),('n8qdcw7ex7bypmy8q796qkahma','10기 부울경1반','https://moassbucket.s3.ap-northeast-2.amazonaws.com/62df6af7-cb11-cdac-3a7c-55f7d08faac2.png'),('nc61uqhaniffifmdkd6maunpro','보충 Python반','https://moassbucket.s3.ap-northeast-2.amazonaws.com/b2b23ab9-fdf0-435d-e7ef-3eda5caa0bf3.png'),('tt19wwyk9tb13g68ne6oz67e1y','10기 공통 부울경1반','https://moassbucket.s3.ap-northeast-2.amazonaws.com/2be358d5-1177-43c5-c668-68a0d698e729.png'),('uhrbu15mw7f88m5btnh6u5dwfa','10기 특화 부울경2반','https://moassbucket.s3.ap-northeast-2.amazonaws.com/bcce827e-54a1-b2e2-ff62-ae3034384bda.png'),('wqtsgsymt3fh8rsxr53bunj68c','특강','https://moassbucket.s3.ap-northeast-2.amazonaws.com/3e64ccf0-5624-b752-5f66-f99240ffbdac.png');
/*!40000 ALTER TABLE `MMTeam` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MMToken`
--

DROP TABLE IF EXISTS `MMToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MMToken` (
  `mm_token_id` int(11) NOT NULL AUTO_INCREMENT,
  `session_token` varchar(40) DEFAULT NULL,
  `user_id` varchar(20) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT utc_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT utc_timestamp(),
  PRIMARY KEY (`mm_token_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `MMToken_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MMToken`
--

LOCK TABLES `MMToken` WRITE;
/*!40000 ALTER TABLE `MMToken` DISABLE KEYS */;
INSERT INTO `MMToken` VALUES (1,'mo6omh6tx78y3bwkkbz3qya85a','1058448','2024-05-19 06:12:48','2024-05-19 06:12:48'),(2,'dozanypbot8g3gm38uysuwfmjo','1055605','2024-05-19 07:40:44','2024-05-19 07:40:44'),(3,'4xkahpc84ifgbny3brijmuxd4c','1053374','2024-05-19 10:45:40','2024-05-19 10:45:40'),(4,'hk98zk44nigwxeu4rw4qefscza','1052881','2024-05-19 12:07:59','2024-05-19 12:07:59'),(5,'obg3bt38wpycinezq14hzw9cew','1058706','2024-05-19 10:12:44','2024-05-19 10:12:44');
/*!40000 ALTER TABLE `MMToken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Position`
--

DROP TABLE IF EXISTS `Position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Position` (
  `position_name` varchar(20) NOT NULL,
  `color_code` varchar(8) NOT NULL DEFAULT '#6ECEF5',
  PRIMARY KEY (`position_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Position`
--

LOCK TABLES `Position` WRITE;
/*!40000 ALTER TABLE `Position` DISABLE KEYS */;
/*!40000 ALTER TABLE `Position` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reservation`
--

DROP TABLE IF EXISTS `Reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reservation` (
  `reservation_id` int(11) NOT NULL AUTO_INCREMENT,
  `class_code` varchar(5) NOT NULL,
  `category` varchar(40) NOT NULL,
  `time_limit` int(11) NOT NULL DEFAULT 2,
  `reservation_name` varchar(40) NOT NULL,
  `color_code` varchar(8) NOT NULL DEFAULT '#6ECEF5',
  PRIMARY KEY (`reservation_id`),
  KEY `class_code` (`class_code`),
  CONSTRAINT `Reservation_ibfk_1` FOREIGN KEY (`class_code`) REFERENCES `Class` (`class_code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reservation`
--

LOCK TABLES `Reservation` WRITE;
/*!40000 ALTER TABLE `Reservation` DISABLE KEYS */;
INSERT INTO `Reservation` VALUES (1,'E2','board',10,'플립보드1','#15c900'),(2,'E2','board',10,'플립보드2','#15c900'),(3,'E2','meeting',1,'개인상담','#aa3333'),(5,'E2','1',1,'팀 미','#1e9c21');
/*!40000 ALTER TABLE `Reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ReservationInfo`
--

DROP TABLE IF EXISTS `ReservationInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ReservationInfo` (
  `info_id` int(11) NOT NULL AUTO_INCREMENT,
  `reservation_id` int(11) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `info_state` int(11) NOT NULL,
  `info_name` varchar(8) NOT NULL,
  `info_date` date NOT NULL,
  `info_time` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT utc_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT utc_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`info_id`),
  KEY `reservation_id` (`reservation_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `ReservationInfo_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `Reservation` (`reservation_id`),
  CONSTRAINT `ReservationInfo_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReservationInfo`
--

LOCK TABLES `ReservationInfo` WRITE;
/*!40000 ALTER TABLE `ReservationInfo` DISABLE KEYS */;
INSERT INTO `ReservationInfo` VALUES (1,1,'1000000',3,'XXXX','9999-12-31',9,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(2,1,'1000000',3,'XXXX','9999-12-31',10,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(3,2,'1000000',3,'XXXX','9999-12-31',9,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(4,2,'1000000',3,'XXXX','9999-12-31',10,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(5,3,'1000000',3,'XXXX','9999-12-31',1,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(6,3,'1000000',3,'XXXX','9999-12-31',9,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(7,3,'1000000',3,'XXXX','9999-12-31',10,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(8,3,'1000000',3,'XXXX','9999-12-31',18,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(9,1,'1050065',1,'피그마 회의','2024-05-20',1,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(10,1,'1050065',1,'피그마 회의','2024-05-20',2,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(11,1,'1050065',1,'피그마 회의','2024-05-20',3,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(12,1,'1050065',1,'피그마 회의','2024-05-20',4,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(13,1,'1050065',1,'피그마 회의','2024-05-20',5,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(14,1,'1050065',1,'피그마 회의','2024-05-20',6,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(15,1,'1050065',1,'피그마 회의','2024-05-20',7,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(16,1,'1050065',1,'피그마 회의','2024-05-20',8,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(17,1,'1050065',1,'피그마 회의','2024-05-20',11,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(18,1,'1050065',1,'피그마 회의','2024-05-20',12,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(19,2,'1050065',1,'피그마 회의2','2024-05-20',1,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(20,2,'1050065',1,'피그마 회의2','2024-05-20',2,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(21,2,'1050065',1,'피그마 회의2','2024-05-20',3,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(22,2,'1050065',1,'피그마 회의2','2024-05-20',4,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(23,2,'1050065',1,'피그마 회의2','2024-05-20',5,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(24,2,'1050065',1,'피그마 회의2','2024-05-20',6,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(25,2,'1050065',1,'피그마 회의2','2024-05-20',7,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(26,2,'1050065',1,'피그마 회의2','2024-05-20',8,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(27,2,'1050065',1,'피그마 회의2','2024-05-20',11,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(28,2,'1050065',1,'피그마 회의2','2024-05-20',12,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(29,1,'1050074',1,'피그마 회의','2024-05-20',13,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(30,1,'1050074',1,'피그마 회의','2024-05-20',14,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(31,1,'1050074',1,'피그마 회의','2024-05-20',15,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(32,1,'1050074',1,'피그마 회의','2024-05-20',16,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(33,1,'1050074',1,'피그마 회의','2024-05-20',17,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(34,1,'1050074',1,'피그마 회의','2024-05-20',18,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(35,2,'1050074',1,'피그마 회의2','2024-05-20',13,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(36,2,'1050074',1,'피그마 회의2','2024-05-20',14,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(37,2,'1050074',1,'피그마 회의2','2024-05-20',15,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(38,2,'1050074',1,'피그마 회의2','2024-05-20',16,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(39,2,'1050074',1,'피그마 회의2','2024-05-20',17,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(40,2,'1050074',1,'피그마 회의2','2024-05-20',18,'2024-05-19 11:47:42','2024-05-19 11:47:42'),(41,3,'1052881',1,'취업상담','2024-05-20',16,'2024-05-19 11:55:01','2024-05-19 11:55:01'),(45,5,'1000000',3,'XXXX','9999-12-31',8,'2024-05-19 17:05:25','2024-05-19 17:05:25'),(46,5,'1000000',3,'XXXX','9999-12-31',9,'2024-05-19 17:05:25','2024-05-19 17:05:25'),(47,5,'1000000',3,'XXXX','9999-12-31',10,'2024-05-19 17:05:25','2024-05-19 17:05:25');
/*!40000 ALTER TABLE `ReservationInfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Screenshot`
--

DROP TABLE IF EXISTS `Screenshot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Screenshot` (
  `screenshot_id` int(11) NOT NULL AUTO_INCREMENT,
  `screenshot_url` varchar(255) DEFAULT NULL,
  `board_user_id` int(11) NOT NULL,
  PRIMARY KEY (`screenshot_id`),
  KEY `board_user_id` (`board_user_id`),
  CONSTRAINT `Screenshot_ibfk_1` FOREIGN KEY (`board_user_id`) REFERENCES `BoardUser` (`board_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Screenshot`
--

LOCK TABLES `Screenshot` WRITE;
/*!40000 ALTER TABLE `Screenshot` DISABLE KEYS */;
INSERT INTO `Screenshot` VALUES (1,'https://moassbucket.s3.ap-northeast-2.amazonaws.com/screenshot1.PNG',1),(2,'https://moassbucket.s3.ap-northeast-2.amazonaws.com/screenshot2.PNG',2),(3,'https://moassbucket.s3.ap-northeast-2.amazonaws.com/screenshot3.PNG',2);
/*!40000 ALTER TABLE `Screenshot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SsafyUser`
--

DROP TABLE IF EXISTS `SsafyUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SsafyUser` (
  `user_id` varchar(20) NOT NULL,
  `job_code` int(11) NOT NULL,
  `team_code` varchar(5) NOT NULL,
  `user_name` varchar(10) NOT NULL,
  `card_serial_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `team_code` (`team_code`),
  CONSTRAINT `SsafyUser_ibfk_1` FOREIGN KEY (`team_code`) REFERENCES `Team` (`team_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SsafyUser`
--

LOCK TABLES `SsafyUser` WRITE;
/*!40000 ALTER TABLE `SsafyUser` DISABLE KEYS */;
INSERT INTO `SsafyUser` VALUES ('1000000',4,'E200','장컨설턴트','MASTERKEY'),('1000001',1,'Z901','홍길동','AAAA1'),('1000002',2,'Z902','김길동','AAAA2'),('1000003',3,'Z903 ','최박사','AAAA3'),('1000004',3,'Z904 ','홍박사','AAAA4'),('1000005',1,'Z901','박길동','AAAA5'),('1000006',1,'Z901','최길동','AAAA6'),('1050011',1,'E201','김동우','EEEE11'),('1050012',1,'E201','김가영','EEEE12'),('1050013',1,'E201','박나린','EEEE13'),('1050014',1,'E201','주혜련','EEEE14'),('1050015',1,'E201','양윤모','EEEE15'),('1050016',1,'E201','김영대','EEEE16'),('1050017',1,'E201','최용훈','EEEE17'),('1050031',1,'E204','진성민','EEEE31'),('1050032',1,'E204','박민호','EEEE32'),('1050033',1,'E204','문지호','EEEE33'),('1050034',1,'E204','김민','EEEE34'),('1050035',1,'E204','김영후','EEEE35'),('1050036',1,'E204','위동민','EEEE36'),('1050041',1,'E207','정세진','EEEE41'),('1050042',1,'E207','황호철','EEEE42'),('1050043',1,'E207','김동현','EEEE43'),('1050044',1,'E207','신현기','EEEE44'),('1050045',1,'E207','장수영','EEEE45'),('1050046',1,'E207','최명성','EEEE46'),('1050051',1,'E205','이현민','EEEE51'),('1050052',1,'E205','조우재','EEEE52'),('1050053',1,'E205','박정호','EEEE53'),('1050054',1,'E205','조창래','EEEE54'),('1050055',1,'E205','최도훈','EEEE55'),('1050056',1,'E205','박예지','EEEE56'),('1050061',1,'E206','위재원','EEEE61'),('1050062',1,'E206','김창희','EEEE62'),('1050063',1,'E206','최진우','EEEE63'),('1050064',1,'E206','장지민','EEEE64'),('1050065',1,'E206','박수빈','EEEE65'),('1050066',1,'E206','박서현','EEEE66'),('1050071',1,'E202','서준하','EEEE71'),('1050072',1,'E202','김민진','EEEE72'),('1050073',1,'E202','황채원','EEEE73'),('1050074',1,'E202','정종길','EEEE74'),('1050075',1,'E202','이재진','EEEE75'),('1050076',1,'E202','심상익','EEEE76'),('1050077',1,'E202','유영준','EEEE77'),('1052881',1,'E203','한성주','043d2bcc780000'),('1053374',1,'E203','손종민','0422a6bd790000'),('1055555',1,'E204','정종길','EAEA5'),('1055605',1,'E203','장현욱','04305598780000'),('1057753',1,'E203','이동호','04c8ba97780000'),('1058448',1,'E203','원종현','04fc4ccc780000'),('1058706',1,'E203','서지수','04413fbd790000'),('9000001',1,'Z101','김일박','ZZZZ1'),('9000002',1,'Z101','김이박','ZZZZ2'),('9000003',1,'Z101','김삼박','ZZZZ3'),('9000004',1,'Z101','김사박','ZZZZ4'),('9000005',1,'Z101','김오박','ZZZZ5'),('9000011',1,'Z102','갑일박','ZZZZ11'),('9000012',1,'Z102','갑이박','ZZZZ12'),('9000013',1,'Z102','갑삼박','ZZZZ13'),('9000014',1,'Z102','갑사박','ZZZZ14'),('9000015',1,'Z102','갑오박','ZZZZ15'),('9000016',1,'Z103','원종현','ZZZZ21');
/*!40000 ALTER TABLE `SsafyUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Team`
--

DROP TABLE IF EXISTS `Team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Team` (
  `team_code` varchar(5) NOT NULL,
  `team_name` varchar(20) DEFAULT NULL,
  `class_code` varchar(5) NOT NULL,
  PRIMARY KEY (`team_code`),
  KEY `class_code` (`class_code`),
  CONSTRAINT `Team_ibfk_1` FOREIGN KEY (`class_code`) REFERENCES `Class` (`class_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Team`
--

LOCK TABLES `Team` WRITE;
/*!40000 ALTER TABLE `Team` DISABLE KEYS */;
INSERT INTO `Team` VALUES ('A101','A101','A1'),('A102','A102','A1'),('A103','A103','A1'),('A104','A104','A1'),('A105','A105','A1'),('A106','A106','A1'),('A107','A107','A1'),('A201','A201','A2'),('A202','A202','A2'),('A203','A203','A2'),('A301','A301','A3'),('A302','A302','A3'),('A401','A401','A4'),('A402','A402','A4'),('E101','E101','E1'),('E102','E102','E1'),('E103','E103','E1'),('E104','E104','E1'),('E105','E105','E1'),('E106','E106','E1'),('E107','E107','E1'),('E200','E200','E2'),('E201','E201','E2'),('E202','E202','E2'),('E203','후자전자','E2'),('E204','E204','E2'),('E205','E205','E2'),('E206','E206','E2'),('E207','E207','E2'),('Z101','Z101','Z1'),('Z102','Z102','Z1'),('Z103','Z103','Z1'),('Z104','Z104','Z1'),('Z105','Z105','Z1'),('Z106','Z106','Z1'),('Z107','Z107','Z1'),('Z201','Z201','Z2'),('Z202','Z202','Z2'),('Z203','Z203','Z2'),('Z204','Z204','Z2'),('Z205','Z205','Z2'),('Z206','Z206','Z2'),('Z207','Z207','Z2'),('Z901','Z901','Z9'),('Z902','Z902','Z9'),('Z903','Z903','Z9'),('Z904','Z904','Z9');
/*!40000 ALTER TABLE `Team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `user_id` varchar(20) NOT NULL,
  `status_id` int(11) NOT NULL DEFAULT 0,
  `user_email` varchar(40) NOT NULL COMMENT '로그인',
  `password` varchar(255) NOT NULL,
  `profile_img` varchar(255) DEFAULT NULL,
  `background_img` varchar(255) DEFAULT NULL,
  `layout` int(11) NOT NULL DEFAULT 1,
  `connect_flag` int(11) DEFAULT 0,
  `position_name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `FK_SSAFYUser_TO_User_1` FOREIGN KEY (`user_id`) REFERENCES `SsafyUser` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES ('1000000',0,'master@com','$2a$10$OPtI3l5vrLZtGIq900w1EOyxL8VnCaJm5KAg4tIoH7ejeuvwMLBda',NULL,NULL,1,0,NULL),('1000001',0,'test@com','$2a$10$3gDMrFBxTBMEh4kJdVFVzuYzohjzHowqF2kzGuU4I1A38QqtXvmCq',NULL,NULL,1,0,NULL),('1050011',0,'EEEE11@.com','$2a$10$3NOVdEgNxIGENaB2o5wdpuRmdV2soeiiaYMCwgQRtd8rCXGv.NiGO',NULL,NULL,1,0,NULL),('1050012',1,'EEEE12@.com','$2a$10$if9tx/3970v9FxJyDFzJ/.Z7g85G/zdmPb9I11ZxtTeuXrs0KdzIG',NULL,NULL,1,0,NULL),('1050013',1,'EEEE13@.com','$2a$10$Si1SlQ8xamFy51JW5vQ8XOiO35OiSXQrm4lbRMzxnqBJuPgOPZPT2',NULL,NULL,1,0,NULL),('1050014',0,'EEEE14@.com','$2a$10$dKqZ1E/5IGeQu9hj0tPlLehqG.BhC72mrbufI6IJ7JllfeObAiy3W',NULL,NULL,1,0,NULL),('1050015',1,'EEEE15@.com','$2a$10$JY0BZGgEsR0Ub9R.Px5k5OHMoE7Xo8SmmSHCMmVhz.IkZv92ZgSh2',NULL,NULL,1,0,NULL),('1050016',0,'EEEE16@.com','$2a$10$W0RoGc9y8qYIbamLNZE1TOGdOfJJCgAEyM8dQIrfS/rpkYy/By7wi',NULL,NULL,1,0,NULL),('1050017',0,'EEEE17@.com','$2a$10$qA68nw3bqnbLb1D3w82W7.Uce.LixwijbrZiPcKLSmMZny35TIgc6',NULL,NULL,1,0,NULL),('1050031',1,'EEEE31@.com','$2a$10$vo2tOvx.G8velhTlkF2GNO2Cdflp7U6qKut/eJDUCdKn6dCOWvHt2',NULL,NULL,1,0,NULL),('1050032',1,'EEEE32@.com','$2a$10$JTz5xX3EEtN/asK5TDwtOOnWKo394f5eSeEtvJwOGnpcBV2ouijiy',NULL,NULL,1,0,NULL),('1050033',1,'EEEE33@.com','$2a$10$fw7hYMtWgIXtd.OoYiLKzu6VSFdbb3qe2SAuvRLz3kdJV8o/dhZxm',NULL,NULL,1,0,NULL),('1050034',1,'EEEE34@.com','$2a$10$FmBWQZsR/ctFJb0B6P4LU.DK6T7nr65Cw4/0Saaqh7/m9mJDduF3u',NULL,NULL,1,0,NULL),('1050035',1,'EEEE35@.com','$2a$10$AmJ28E8dDVW1SWzAlqR9peYVVP6W/KtGvcVyfPH68MqFKdklTssai',NULL,NULL,1,0,NULL),('1050036',1,'EEEE36@.com','$2a$10$lTrPXU.y/bNKInUpXdI0YOmywOp3V4nKCkIgdfHkZ0fmV5sUj7I0.',NULL,NULL,1,0,NULL),('1050041',1,'EEEE41@.com','$2a$10$RBAQmcwbLoSnzyeAqe/tNeHOttvszLuWEmuvzGaABO83.GUHMYsQ6',NULL,NULL,1,0,NULL),('1050042',1,'EEEE42@.com','$2a$10$MxjSaeURNlNdZalOuoMnnenNhGbTQuWOjpZLu1.kQBu1XhVRouK1G',NULL,NULL,1,0,NULL),('1050043',1,'EEEE43@.com','$2a$10$nj50Lq.2eJHYEC53PNfB3uFZgKip2rAtZGKlybdtgQyKlxoTHxywy',NULL,NULL,1,0,NULL),('1050044',1,'EEEE44@.com','$2a$10$GGPRhJ6xhu2AMwx8.rqO4.ruLsaKoYHd53UqhNJgQL/xmmmBrmtP2',NULL,NULL,1,0,NULL),('1050045',1,'EEEE45@.com','$2a$10$ZDfQL79G95/8oxY4KPD7bOHiPnBfIns57tTE4IXWb8S2hQJdbMux.',NULL,NULL,1,0,NULL),('1050046',1,'EEEE46@.com','$2a$10$I9ORx3PILzKuFXwT/gD1jOcDDd6hzreMt3vtWHuHJBFVR/zDUYXEe',NULL,NULL,1,0,NULL),('1050051',0,'EEEE51@.com','$2a$10$jgaNZKNRU/YdkxzaeA.PvesCBO./9Y6zbNTJFMAWNsw2GNq99osMy',NULL,NULL,1,0,NULL),('1050052',0,'EEEE52@.com','$2a$10$qgwF535fB/eEx94QnsZXt.waS1PWCenILHqN2heDe9kp.y1Feymve',NULL,NULL,1,0,NULL),('1050053',1,'EEEE53@.com','$2a$10$GanqifrEIlPxmM6SywDygOs/20pwGRDlpDKR9C4xYBKlmjQ2aGjRy',NULL,NULL,1,0,NULL),('1050054',0,'EEEE54@.com','$2a$10$o.jLZ1A.YYkeKvrYVvGJ3OTU8oMVi8MLuMna9M14zSSSoJAFROr8.',NULL,NULL,1,0,NULL),('1050055',0,'EEEE55@.com','$2a$10$tD40R9l38cKFGQWvOCfjAepwM1hVNHisiDGmGg4rjZMMv5Wq0sNya',NULL,NULL,1,0,NULL),('1050056',0,'EEEE56@.com','$2a$10$2p52qQ2Qwi.QsKaGNu.9Re7pIHhTbJPYo4qUE0UF6rLmrZRmc3/py',NULL,NULL,1,0,NULL),('1050061',1,'EEEE61@.com','$2a$10$1m2R9epxxozeXY97S0WOOeY2LwxrnIfEheatXepfnUgvtzDcu73UW',NULL,NULL,1,0,NULL),('1050062',1,'EEEE62@.com','$2a$10$3Udx6pKDQAQ98QkebY9lxutzSZcZlpUAue9t30qMJxdUCqFYc4AX6',NULL,NULL,1,0,NULL),('1050063',1,'EEEE63@.com','$2a$10$i8Cjs1PJRw8US0wEJnSJoeseLa.vusOG.lqMGmPLYFn.Z950a/Tmi',NULL,NULL,1,0,NULL),('1050064',1,'EEEE64@.com','$2a$10$bca8YUdag76XVeUqks3ymutEQc8dDegyyvVBRMoN6vKMAEx5x9Yze',NULL,NULL,1,0,NULL),('1050065',1,'EEEE65@.com','$2a$10$tXd.SSX9GAU7WK93zp6t4esXa4bdzHWTEMUVrj086DsymdL9neODS',NULL,NULL,1,0,NULL),('1050066',1,'EEEE66@.com','$2a$10$2fe.VVL/1j5Hg72xoEM1j.wACJZeKXjqwhuBbtNIZAjad78rLuVVu',NULL,NULL,1,0,NULL),('1050071',1,'EEEE71@.com','$2a$10$nESY1kjGkt1JhQ426i59TOQ19zIMGwKDHCSRSWcUvkUBmp6vle512',NULL,NULL,1,0,NULL),('1050072',1,'EEEE72@.com','$2a$10$rfW/uTREJl0A30XLOIDPeeYlouGp6VzCKF7qYRzt.X0OukQNY2oEW',NULL,NULL,1,0,NULL),('1050073',0,'EEEE73@.com','$2a$10$xFzGdWGFdMd66Uem875LpO763SJ8NVuGSiQmEzbnVr766cR72U/fi',NULL,NULL,1,0,NULL),('1050074',0,'EEEE74@.com','$2a$10$wu0AuNs9/VyvUblzy0KGrufiCCVC4VpOsFiJ/g3o9X/jHn10WD5C6',NULL,NULL,1,0,NULL),('1050075',0,'EEEE75@.com','$2a$10$GfLtaeltIyzXDXyhg7XiW.bEo6x7QBiS7cN/81wJitai980Zh0Zq6',NULL,NULL,1,0,NULL),('1050076',1,'EEEE76@.com','$2a$10$U5/./jp7nat9r0Vh2cVMDeLXgIRvVgke7nUmFWCmfajXS8MesP2ha',NULL,NULL,1,0,NULL),('1050077',0,'EEEE77@.com','$2a$10$iqMuB184jUlifQlCqNdAd.zaytmS2rjMxBDMeW6PbpIhnXFexfa52',NULL,NULL,1,0,NULL),('1052881',1,'hsj990604@gmail.com','$2a$10$u.GzejsjpIQQkxa3XOOF0ub5hhbgno0RjY6w6fh3rSZHcIHQpXTyS','https://moassbucket.s3.ap-northeast-2.amazonaws.com/b5960b6e-9789-489a-993c-de1869ac9938.jpeg',NULL,1,1,'EM'),('1053374',0,'kain9101@naver.com','$2a$10$Mu5PR/IWYpN1tBPThHvnlOhdru6t3s.kE9qXJgag3JPYtn3oNLdRK','https://moassbucket.s3.ap-northeast-2.amazonaws.com/42f1d776-132d-4778-9e40-100967d19811.jpeg','https://moassbucket.s3.ap-northeast-2.amazonaws.com/399fa703-fdfc-455b-8819-4f3b65c11d93.jpeg',1,0,'FE'),('1055555',0,'EAEA1@.com','$2a$10$1/NXVXl.XxZfPGnbt.4F.OmsfkizyWo8RNFINWbP9EMvGK1L//Y2K',NULL,NULL,1,0,NULL),('1055605',0,'chiru7080@daum.net','$2a$10$NGVngLGoB//2oK6T/oyItOO3bdjyZ2m489m57F5ykd9tuPSRKZf9q',NULL,NULL,1,0,NULL),('1057753',0,'ghehd1125@gmail.com','$2a$10$XGNdRnnrxE6ulKtCooOA3eSs/urUO6VMly8uq2PgBPVvGRJGR09im','https://moassbucket.s3.ap-northeast-2.amazonaws.com/9c410464-0eb3-4902-9a21-56a569ca5e65.jpeg',NULL,1,0,NULL),('1058448',0,'weon1009@gmail.com','$2a$10$TdPEXNXHLiRmQXG9vjgJyufJTrJDShhyy6YpYqjrDd7g9wmze03F.','https://moassbucket.s3.ap-northeast-2.amazonaws.com/cbb3dffb-83a8-4a2e-8139-8005817734cb.jpeg',NULL,1,0,NULL),('1058706',1,'diduedidue@naver.com','$2a$10$ySxcZX5d81qE.HFtmXrUEeLBQrJiqIwaVOhadSka8vwyGUmSdVyGG','https://moassbucket.s3.ap-northeast-2.amazonaws.com/9bdcbf9d-12f8-408d-93fd-a094a10f49a8.jpeg',NULL,1,1,'EM'),('9000001',0,'Z001@com','$2a$10$O9xbQXYx.4vsE/qcKHuuBO3QbHKq2KdCbAiujjMxyQNJRWtqJY3fi','https://moassbucket.s3.ap-northeast-2.amazonaws.com/9c410464-0eb3-4902-9a21-56a569ca5e65.jpeg',NULL,1,0,NULL),('9000002',0,'Z002@com','$2a$10$603QAWwY92dRNB4uf6q0zettWLCVktzHj7EX5UiyLftouOBR0iQ1m',NULL,NULL,1,0,NULL),('9000003',0,'Z003@com','$2a$10$KR6EBilef0GwtBR.Mar3nOpUJQy1VniFWblTJTmLC6E.k0a5lgv2u',NULL,NULL,1,0,NULL),('9000004',0,'Z004@com','$2a$10$lfYATs9UGjUCluBbcRi1vuXIU00U92hYGTXV4nH1gJKUFXYnD8BwS',NULL,NULL,1,0,NULL),('9000005',0,'Z005@com','$2a$10$YUwWf5MPuDFp4S2yAOcwje2lsYUIChVwKjsY63YYnWEAlofA8MYsC',NULL,NULL,1,0,NULL),('9000011',0,'Z011@com','$2a$10$yipFn5zwNfAJIMnzY4ehDOt.hh4bjjH3xWK9zkX0PfgCrDUYyNQiK',NULL,NULL,1,0,NULL),('9000012',0,'Z012@com','$2a$10$AmYdbYT4LiGocXBUTLa.hudy5T32DFD0.FacXcnGBMLmXjv4Qf10O',NULL,NULL,1,0,NULL),('9000013',0,'Z013@com','$2a$10$3RZKdq3kOspS6glw9wH6.eYxKP1pIhgLCe1.fZlLB7Js055vdBNG6',NULL,NULL,1,0,NULL),('9000014',0,'Z014@com','$2a$10$paH6IhhqTRWD7kapAPuVgOaqBlSIrS2BrPw6U26/71/irsKLtyQ1q',NULL,NULL,1,0,NULL),('9000015',0,'Z015@com','$2a$10$Ih6mA8oVP0W1Y2V2M4KOh.1bn2IUVLV8iXO2bENbAXmXUogaV0.Vi',NULL,NULL,1,0,NULL);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserMMChannel`
--

DROP TABLE IF EXISTS `UserMMChannel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserMMChannel` (
  `user_id` varchar(20) NOT NULL,
  `mm_channel_id` varchar(40) NOT NULL,
  KEY `FK_User_TO_UserMMChannel_1` (`user_id`),
  KEY `FK_MMChannel_TO_UserMMChannel_1` (`mm_channel_id`),
  CONSTRAINT `FK_MMChannel_TO_UserMMChannel_1` FOREIGN KEY (`mm_channel_id`) REFERENCES `MMChannel` (`mm_channel_id`),
  CONSTRAINT `FK_User_TO_UserMMChannel_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserMMChannel`
--

LOCK TABLES `UserMMChannel` WRITE;
/*!40000 ALTER TABLE `UserMMChannel` DISABLE KEYS */;
INSERT INTO `UserMMChannel` VALUES ('1055605','tys3hjt6s3dr8bw1q4rksbznkr'),('1053374','3ehq66o1yjn7mc8uggk1885f4r'),('1053374','nhdgqk3t93r1tdhdn9hb5tpbky'),('1058706','muh5russsifbxgrz33jenqtc5w'),('1058706','puwipjbt7bygjfbgjkpr1nzx9w'),('1052881','ia577uta3p8a9ypqwz9c4a1kro');
/*!40000 ALTER TABLE `UserMMChannel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserReservationInfo`
--

DROP TABLE IF EXISTS `UserReservationInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserReservationInfo` (
  `info_id` int(11) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  PRIMARY KEY (`info_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `UserReservationInfo_ibfk_1` FOREIGN KEY (`info_id`) REFERENCES `ReservationInfo` (`info_id`),
  CONSTRAINT `UserReservationInfo_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserReservationInfo`
--

LOCK TABLES `UserReservationInfo` WRITE;
/*!40000 ALTER TABLE `UserReservationInfo` DISABLE KEYS */;
INSERT INTO `UserReservationInfo` VALUES (1,'1000000'),(2,'1000000'),(3,'1000000'),(4,'1000000'),(5,'1000000'),(6,'1000000'),(7,'1000000'),(8,'1000000'),(9,'1050065'),(10,'1050065'),(11,'1050065'),(12,'1050065'),(13,'1050065'),(14,'1050065'),(15,'1050065'),(16,'1050065'),(17,'1050065'),(18,'1050065'),(19,'1050065'),(20,'1050065'),(21,'1050065'),(22,'1050065'),(23,'1050065'),(24,'1050065'),(25,'1050065'),(26,'1050065'),(27,'1050065'),(28,'1050065'),(29,'1055555'),(30,'1055555'),(31,'1055555'),(32,'1055555'),(33,'1055555'),(34,'1055555'),(35,'1055555'),(36,'1055555'),(37,'1055555'),(38,'1055555'),(39,'1055555'),(40,'1055555'),(41,'1052881'),(45,'1000000'),(46,'1000000'),(47,'1000000');
/*!40000 ALTER TABLE `UserReservationInfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Widget`
--

DROP TABLE IF EXISTS `Widget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Widget` (
  `widget_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(20) NOT NULL,
  `widget_img` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT utc_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT utc_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`widget_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `Widget_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Widget`
--

LOCK TABLES `Widget` WRITE;
/*!40000 ALTER TABLE `Widget` DISABLE KEYS */;
/*!40000 ALTER TABLE `Widget` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-20 14:57:50
