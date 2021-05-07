
DROP TABLE IF EXISTS `dim_agency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_agency` (
  `agency_key` int NOT NULL AUTO_INCREMENT,
  `agency_init` varchar(5) DEFAULT NULL,
  `agency_name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`agency_key`)
);

DROP TABLE IF EXISTS `dim_borough`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_borough` (
  `borough_key` int NOT NULL AUTO_INCREMENT,
  `borough_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`borough_key`)
);

DROP TABLE IF EXISTS `dim_cd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_cd` (
  `cd_key` int NOT NULL AUTO_INCREMENT,
  `complaint_descriptor` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`cd_key`)
);

DROP TABLE IF EXISTS `dim_channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_channel` (
  `channel_key` int NOT NULL AUTO_INCREMENT,
  `channel_type` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`channel_key`)
);

DROP TABLE IF EXISTS `dim_city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_city` (
  `city_key` int NOT NULL AUTO_INCREMENT,
  `city_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`city_key`)
);

DROP TABLE IF EXISTS `dim_ct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_ct` (
  `ct_key` int NOT NULL AUTO_INCREMENT,
  `complaint_type` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ct_key`)
);


DROP TABLE IF EXISTS `dim_date`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_date` (
  `date_key` int NOT NULL AUTO_INCREMENT,
  `date_str` varchar(45) DEFAULT NULL,
  `date_year` int DEFAULT NULL,
  `date_month` int DEFAULT NULL,
  `date_day` int DEFAULT NULL,
  `date_quarter` int DEFAULT NULL,
  `date_weekday` int DEFAULT NULL,
  `date_week` int DEFAULT NULL,
  PRIMARY KEY (`date_key`)
);

DROP TABLE IF EXISTS `dim_median_income`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_median_income` (
  `median_income_key` int NOT NULL AUTO_INCREMENT,
  `median_income` bigint DEFAULT NULL,
  `zipcode` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`median_income_key`)
);

DROP TABLE IF EXISTS `dim_resolution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_resolution` (
  `resolution_key` int NOT NULL AUTO_INCREMENT,
  `resolution_descriptor` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`resolution_key`)
);

DROP TABLE IF EXISTS `dim_zcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_zcode` (
  `zcode_key` int NOT NULL AUTO_INCREMENT,
  `zip_code` int DEFAULT NULL,
  PRIMARY KEY (`zcode_key`)
);

DROP TABLE IF EXISTS `fact_311`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fact_311` (
  `agency_key` int DEFAULT NULL,
  `borough_key` int DEFAULT NULL,
  `cd_key` int DEFAULT NULL COMMENT 'complaint descriptor',
  `channel_key` int DEFAULT NULL,
  `city_key` int DEFAULT NULL,
  `ct_key` int DEFAULT NULL COMMENT 'complaint type',
  `resolution_key` int DEFAULT NULL,
  `zipcode_key` int DEFAULT NULL,
  `create_date_key` int DEFAULT NULL,
  `create_date_hour` int DEFAULT NULL,
  `resolution_date_key` int DEFAULT NULL,
  `resolution_date_hour` int DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `median_income_key` int DEFAULT NULL,
  `unique_id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`unique_id`),
  KEY `fk_f_311_01_idx` (`agency_key`),
  KEY `fk_f_311_02_idx` (`borough_key`),
  KEY `fk_f_311_03_idx` (`cd_key`),
  KEY `fk_f_311_04_idx` (`channel_key`),
  KEY `fk_f_311_05_idx` (`city_key`),
  KEY `fk_f_311_06_idx` (`ct_key`),
  KEY `fk_f_311_07_idx` (`resolution_key`),
  KEY `fk_f_311_08_idx` (`zipcode_key`),
  KEY `fk_f_311_09_idx` (`create_date_key`),
  KEY `fk_f_311_10_idx` (`resolution_date_key`),
  KEY `fk_f_311_11_idx` (`median_income_key`),
  CONSTRAINT `fk_f_311_01` FOREIGN KEY (`agency_key`) REFERENCES `dim_agency` (`agency_key`),
  CONSTRAINT `fk_f_311_02` FOREIGN KEY (`borough_key`) REFERENCES `dim_borough` (`borough_key`),
  CONSTRAINT `fk_f_311_03` FOREIGN KEY (`cd_key`) REFERENCES `dim_cd` (`cd_key`),
  CONSTRAINT `fk_f_311_04` FOREIGN KEY (`channel_key`) REFERENCES `dim_channel` (`channel_key`),
  CONSTRAINT `fk_f_311_05` FOREIGN KEY (`city_key`) REFERENCES `dim_city` (`city_key`),
  CONSTRAINT `fk_f_311_06` FOREIGN KEY (`ct_key`) REFERENCES `dim_ct` (`ct_key`),
  CONSTRAINT `fk_f_311_07` FOREIGN KEY (`resolution_key`) REFERENCES `dim_resolution` (`resolution_key`),
  CONSTRAINT `fk_f_311_08` FOREIGN KEY (`zipcode_key`) REFERENCES `dim_zcode` (`zcode_key`),
  CONSTRAINT `fk_f_311_09` FOREIGN KEY (`create_date_key`) REFERENCES `dim_date` (`date_key`),
  CONSTRAINT `fk_f_311_10` FOREIGN KEY (`resolution_date_key`) REFERENCES `dim_date` (`date_key`),
  CONSTRAINT `fk_f_311_11` FOREIGN KEY (`median_income_key`) REFERENCES `dim_median_income` (`median_income_key`)
);

DROP TABLE IF EXISTS `fact_covid19_borough_caserate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fact_covid19_borough_caserate` (
  `borough_key` int DEFAULT NULL,
  `week_ending_date_key` int DEFAULT NULL,
  `caserate` double DEFAULT NULL,
  KEY `fk_c19_b_cr_01_idx` (`borough_key`),
  KEY `fk_c19_b_cr_02_idx` (`week_ending_date_key`),
  CONSTRAINT `fk_c19_b_cr_01` FOREIGN KEY (`borough_key`) REFERENCES `dim_borough` (`borough_key`),
  CONSTRAINT `fk_c19_b_cr_02` FOREIGN KEY (`week_ending_date_key`) REFERENCES `dim_date` (`date_key`)
);

DROP TABLE IF EXISTS `fact_covid19_zipcode_caserate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fact_covid19_zipcode_caserate` (
  `zipcode_key` int DEFAULT NULL,
  `week_ending_date_key` int DEFAULT NULL,
  `caserate` double DEFAULT NULL,
  KEY `fk_c19_zip_cr_01_idx` (`zipcode_key`),
  KEY `fk_c19_zip_cr_02_idx` (`week_ending_date_key`),
  CONSTRAINT `fk_c19_zip_cr_01` FOREIGN KEY (`zipcode_key`) REFERENCES `dim_zcode` (`zcode_key`),
  CONSTRAINT `fk_c19_zip_cr_02` FOREIGN KEY (`week_ending_date_key`) REFERENCES `dim_date` (`date_key`)
)；