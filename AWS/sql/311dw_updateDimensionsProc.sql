DELIMITER $$
CREATE PROCEDURE `updateDimensionsProc`()
BEGIN
  
SET @@SESSION.sql_mode='ALLOW_INVALID_DATES';
#Update agency Dimension
SET FOREIGN_KEY_CHECKS=0;

TRUNCATE TABLE  `311_dw`.`dim_date`;

INSERT INTO `311_dw`.`dim_date`
(
`date_str`,
`date_year`,
`date_month`,
`date_day`,
`date_quarter`,
`date_weekday`,
`date_week`)
(select date_id, Year(date_id), Month(date_id), Day(date_id), Quarter(date_id), 
	WeekDay(date_id), Week(date_id) from (
select date_id from 311_dw.date_temp where date_id <= now()) a);

TRUNCATE TABLE  311_dw.dim_agency;
insert into 311_dw.dim_agency 
(agency_init, agency_name)
(select distinct agency, agency_name from m4.t_311_items);

TRUNCATE TABLE  311_dw.dim_borough;
insert into 311_dw.dim_borough
(borough_name)
(select distinct borough from m4.t_311_items);

TRUNCATE TABLE  311_dw.dim_cd;
insert into 311_dw.dim_cd
(complaint_descriptor)
(select distinct descriptor from m4.t_311_items);

TRUNCATE TABLE  311_dw.dim_channel;
insert into 311_dw.dim_channel
(channel_type)
(select distinct open_data_channel_type from m4.t_311_items);

TRUNCATE TABLE  311_dw.dim_ct;
insert into 311_dw.dim_ct
(complaint_type)
(select distinct complaint_type from m4.t_311_items);

TRUNCATE TABLE  311_dw.dim_city;
insert into 311_dw.dim_city
(city_name)
(select distinct city from m4.t_311_items);

TRUNCATE TABLE  311_dw.dim_resolution;
insert into 311_dw.dim_resolution
(resolution_descriptor)
(select distinct resolution_description from m4.t_311_items);

TRUNCATE TABLE  311_dw.dim_zcode;
insert into 311_dw.dim_zcode
(zip_code)
(select distinct incident_zip from m4.t_311_items);

TRUNCATE TABLE  311_dw.dim_median_income;
insert into 311_dw.dim_median_income
(zipcode, median_income)
(select Location, Families from m4.nyc_median_income_zipcode);

TRUNCATE TABLE  311_dw.fact_covid19_zipcode_caserate;
INSERT INTO `311_dw`.`fact_covid19_zipcode_caserate`
(`zipcode_key`,
`week_ending_date_key`,
`caserate`)
select z.zcode_key, dd.date_key, c.caserate
from m4.covid19_zipcode_caserate c 
left join 311_dw.dim_zcode z on c.zipcode = z.zip_code
left join 311_dw.dim_date dd on DATE_FORMAT(STR_TO_DATE(c.week_ending, "%m/%d/%Y"), '%Y-%m-%d') = dd.date_str;

TRUNCATE TABLE  311_dw.fact_covid19_borough_caserate;
INSERT INTO `311_dw`.`fact_covid19_borough_caserate`
(`borough_key`,
`week_ending_date_key`,
`caserate`)
select b.borough_key, dd.date_key, c.caserate
from m4.covid19_borough_caserate c 
left join 311_dw.dim_borough b on c.borough = b.borough_name
left join 311_dw.dim_date dd on DATE_FORMAT(STR_TO_DATE(c.week_ending, "%m/%d/%Y"), '%Y-%m-%d') = dd.date_str;

TRUNCATE TABLE  311_dw.fact_311;
INSERT INTO `311_dw`.`fact_311`
(`agency_key`,
`borough_key`,
`cd_key`,
`channel_key`,
`city_key`,
`ct_key`,
`resolution_key`,
`zipcode_key`,
`create_date_key`,
`create_date_hour`,
`resolution_date_key`,
`resolution_date_hour`,
`latitude`,
`longitude`,
`median_income_key`
)
(
select ag.agency_key, bo.borough_key, cd.cd_key, ch.channel_key, city.city_key,
	ct.ct_key, res.resolution_key, zcode.zcode_key, dd.date_key, HOUR(i.created_date),
    dd_resolution.date_key, HOUR(i.resolution_action_updated_date), i.latitude, i.longitude,
    income.median_income_key
 from m4.t_311_items i 
left join 311_dw.dim_agency ag on i.agency = ag.agency_init and i.agency_name = ag.agency_name
left join 311_dw.dim_borough bo on i.borough = bo.borough_name
left join 311_dw.dim_cd cd on i.descriptor = cd.complaint_descriptor
left join 311_dw.dim_channel ch on i.open_data_channel_type = ch.channel_type
left join 311_dw.dim_city city on i.city = city.city_name
left join 311_dw.dim_ct ct on i.complaint_type = ct.complaint_type
left join 311_dw.dim_resolution res on i.resolution_description = res.resolution_descriptor
left join 311_dw.dim_zcode zcode on i.incident_zip = zcode.zip_code
left join 311_dw.dim_date dd on DATE_FORMAT(i.created_date, '%Y-%m-%d') = dd.date_str
left join 311_dw.dim_date dd_resolution on DATE_FORMAT(i.resolution_action_updated_date, '%Y-%m-%d') = dd_resolution.date_str
left join 311_dw.dim_median_income income on i.incident_zip = income.zipcode
where i.city is not null)
;

SET FOREIGN_KEY_CHECKS=1;
commit;
END$$
DELIMITER ;