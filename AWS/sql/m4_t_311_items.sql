-- MySQL dump 10.13  Distrib 8.0.23, for Win64 (x86_64)
--
-- Host: m4-test-2.cwog1e14mewr.us-east-1.rds.amazonaws.com    Database: m4
-- ------------------------------------------------------
-- Server version	8.0.20

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '';

--
-- Table structure for table `t_311_items`
--

DROP TABLE IF EXISTS `t_311_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_311_items` (
  `unique_key` bigint DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `closed_date` datetime DEFAULT NULL,
  `agency` varchar(100) DEFAULT NULL,
  `agency_name` varchar(100) DEFAULT NULL,
  `complaint_type` varchar(300) DEFAULT NULL,
  `descriptor` varchar(1000) DEFAULT NULL,
  `incident_zip` varchar(10) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `status` text,
  `resolution_description` varchar(1000) DEFAULT NULL,
  `resolution_action_updated_date` datetime DEFAULT NULL,
  `borough` varchar(50) DEFAULT NULL,
  `open_data_channel_type` varchar(50) DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  KEY `idx_311_items_01` (`created_date`),
  KEY `idx_311_items_02` (`agency`,`agency_name`),
  KEY `idx_311_items_03` (`borough`),
  KEY `idx_311_items_04` (`city`),
  KEY `idx_311_items_05` (`complaint_type`),
  KEY `idx_311_items_06` (`descriptor`(768)),
  KEY `idx_311_items_07` (`open_data_channel_type`),
  KEY `idx_311_items_08` (`resolution_description`(768)),
  KEY `idx_311_items_09` (`resolution_action_updated_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-05-06 22:04:29
