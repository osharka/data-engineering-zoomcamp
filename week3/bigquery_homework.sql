CREATE OR REPLACE EXTERNAL TABLE `dtc-de-339117.trips_data_all.external_fhv_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://dtc_data_lake_dtc-de-339117/raw/fhv_tripdata_2019-*.parquet']
);

-- Check data
SELECT * FROM trips_data_all.external_fhv_tripdata limit 10;

--Question 1: What is count for fhv vehicles data for year 2019 
select count(*)
from `dtc-de-339117.trips_data_all.external_fhv_tripdata`

--Question 2: How many distinct dispatching_base_num we have in fhv for 2019
select count(distinct dispatching_base_num)
from `dtc-de-339117.trips_data_all.external_fhv_tripdata`

--Question 4: What is the count, estimated and actual data processed for query which 
--counts trip between 2019/01/01 and 2019/03/31 for dispatching_base_num B00987, B02060, B02279

-- Creating a partition and cluster table
CREATE OR REPLACE TABLE trips_data_all.fhv_tripdata_partitoned_clustered
PARTITION BY DATE(pickup_datetime)
CLUSTER BY dispatching_base_num AS
SELECT * FROM trips_data_all.external_fhv_tripdata;

SELECT count(*) 
FROM `dtc-de-339117.trips_data_all.fhv_tripdata_partitoned_clustered`
WHERE DATE(pickup_datetime) between '2019-01-01' AND '2019-03-31'
AND dispatching_base_num in ('B00987', 'B02060', 'B02279') 

--Question 5: What will be the best partitioning or clustering strategy when 
--filtering on dispatching_base_num and SR_Flag 

SELECT count(*) 
FROM `dtc-de-339117.trips_data_all.fhv_tripdata_partitoned_clustered`
--42084899 rows at all 

SELECT SR_Flag, count(*) 
FROM `dtc-de-339117.trips_data_all.fhv_tripdata_partitoned_clustered`
group by SR_Flag
order by count(*) desc

-- null 36701264
--1  2369823
--2  1874968
--3  749388
--4  229875
--5  87381

SELECT count(distinct dispatching_base_num) 
FROM `dtc-de-339117.trips_data_all.fhv_tripdata_partitoned_clustered`
--792

SELECT dispatching_base_num, count(*) 
FROM `dtc-de-339117.trips_data_all.fhv_tripdata_partitoned_clustered`
group by dispatching_base_num 
order by count(*) desc
