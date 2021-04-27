SELECT * FROM m4.t_311_agency;

insert into 311_dw.dim_agency 
(agency_init, agency_name)
(select agency, agency_name from m4.t_311_agency);

select * from 311_dw.dim_agency;

SELECT * FROM m4.t_311_borough;

insert into 311_dw.dim_borough
(borough_name)
(select borough from m4.t_311_borough);

select * from 311_dw.dim_borough;

SELECT * FROM m4.t_311_complaint_descriptor;

insert into 311_dw.dim_cd
(complaint_descriptor)
(select complaint_descriptor from m4.t_311_complaint_descriptor);

select * from 311_dw.dim_cd;

SELECT * FROM m4.t_311_open_data_channel_type;

insert into 311_dw.dim_channel
(channel_type)
(select open_data_channel_type from m4.t_311_open_data_channel_type);

select * from 311_dw.dim_channel;

SELECT * FROM m4.t_311_city;

insert into 311_dw.dim_ct
(city_name)
(select city from m4.t_311_city);

select * from 311_dw.dim_city;

SELECT * FROM m4.t_311_complaint_type;

insert into 311_dw.dim_ct
(complaint_type)
(select complaint_type from m4.t_311_complaint_type);

select * from 311_dw.dim_ct;




select * from m4.t_311_resolution_description;

insert into 311_dw.dim_resolution
(resolution_descriptor)
(select resolution_description from m4.t_311_resolution_description);

select * from 311_dw.dim_resolution;

insert into 311_dw.dim_zcode
(zip_code)
(select zipcode from m4.t_311_zipcode);

select * from 311_dw.dim_zcode;




													