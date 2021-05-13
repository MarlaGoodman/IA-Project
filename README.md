# IA-Project

# 1 Introduction

This project is the final project for the Information Architectures course in Yeshiva University's Data Analytics and Visualization Graduate program. 
Team members are Jiaqi Min, Alan Leidner, Yuehao Wang, Ke Chen, and Marla Goodman

The project focuses on data from NYC 311's database.

* Problem: The general problem we are trying to solve is how can we analyze and understand the effect of outside variables on 311 complaints. 
* Solution: Build a warehouse that updates automatically, and where it is easy to integrate other resources into, with frontend dashboard. As a proof of concept we will analyze the effect of covid and income levels on a subset of 311 complaints, noise complaints.


In this Github, there will be files scripts that created our database and datawarehouse in MySQL workbench from the 311 data. 

There will be charts and a Juptyer Notebook that examines the data for any statistical significance.

There will also be a Tableau Notebook that connects directly to the AWS architectrue.

# 2 Deploy AWS
## 2.1 Create S3 and upload history data into S3

- 2.1.1 In AWS create a bucket named it. For example, bucket name: information-arch-yuehao-wang-assignment-8a

- 2.1.2 Upload 4 files that are in the /AWS/data/ into the above bucket.
  covid19_borough_caserate.csv
  covid19_zipcode_caserate.csv
  nyc_median_income_zipcode.csv
  311_Service_Requests_from_2019_to_Present.csv (It is over 1.4GB. The Github does not allowed to upload it. We can use the S3 file)


## 2.2 Create RDS and create databases(schemas)
- 2.2.1 Create a new Mysql 8.0 instance in RDS and give a name. For example, ia_final
- 2.2.2 Use Mysql Workbench to connect to the new RDS instance
  - create a schema for original data. Name is m4. It stories original data from different data sources.
    - run /AWS/sql/m4_t_311_items.sql

  - create a schema for data warehouse. Name is 311_dw. It stories the Star-Model data warhouse.
    - run /AWS/sql/311_dw_ddl.sql
    - run /AWS/sql/311dw_init_date_temp_proc.sql
    - run /AWS/sql/311dw_updateDimensionsProc.sql
  
  - upload history data
    - history data of NYC median income. Open \AWS\script\jupyter311data_nyc_median_income_zipcode.ipynb. Modify file path to you local path, S3 paht or Github path. Run it.
    - history data of NYC 311. Open \AWS\script\311data_history_to_rds.ipynb. Modify file path to you local path, S3 paht or Github path. Run it.

  ![plot](./AWS/img/database.png)

## 2.3 Create lambda functions
- 2.3.1 zip all python scripts in /AWS/script without the /AWS/script/jupter. Name is function.zip

- 2.3.2 create a layer. 
  - Name is pandas-mysql-request
  - upload the \AWS\sources\panda_layer.zip

- 2.3.3 create 5 functions
  - 1) 311data_daily_save_to_s3
    - upload the function.zip
    - add a layer for it and select pandas-mysql-request
  - 2) 311data_covid19_cases_to_s3_daily
    - upload the function.zip
    - add a layer for it and select pandas-mysql-request
  - 3) 311data_daily_data_to_rds
    - upload the function.zip
    - add VPC. The VPC is small with instance of RDS
  - 4) 311data_covid19_cases_to_rds_daily
    - upload the function.zip
    - add VPC. The VPC is small with instance of RDS
  - 5) 311_daily_dw_update_stored_procedure. It will call storied proceduce to finish the Level-1 data warehouse.
    - upload the function.zip
    - add VPC. The VPC is small with instance of RDS
  ![plot](./AWS/img/lambda.png)

## 2.4 Schedule the lambda functions
  - Open EventBridge (CloudWatch Events)
  - create a rule. Runing time is 3：00am/per day. Select the Lambda function (311data_daily_save_to_s3) as target.
  - create a rule. Runing time is 3:15am/per day. Select the Lambda function (311data_covid19_cases_to_s3_daily_rule) as target.
  - create a rule. Runing time is 3:30am/per day. Select the Lambda function (311data_daily_data_to_rds_rule) as target.
  - create a rule. Runing time is 3:45am/per day. Select the Lambda function (311data_covid19_cases_to_rds_daily_rule) as target.
  - create a rule. Runing time is 4：00am/per day. Select the Lambda function (311_daily_dw_update_stored_procedure_rule) as target.

  ![plot](./AWS/img/eventbridge.png)
  
# 3 Create Visualization

# 4 Analyze Data

