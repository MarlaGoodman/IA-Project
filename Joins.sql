use 311_dw;
SELECT a.complaint_type, c.date_year, b.ct_key
FROM fact_311 as b 
JOIN dim_ct as a 
ON a.ct_key=b.ct_key
JOIN  dim_date as c
ON c.date_key=b.create_date_key
WHERE (a.complaint_type like '%unsanitary%' OR a.complaint_type like '%system%' OR a.complaint_type like '%Illegal%'
AND c.date_year != 2021);

use 311_dw;
SELECT a.complaint_type, c.date_year, b.ct_key
FROM fact_311 as b 
JOIN dim_ct as a 
ON a.ct_key=b.ct_key
JOIN  dim_date as c
ON c.date_key=b.create_date_key
WHERE a.complaint_type like '%noise%'
AND c.date_year != 2021;





