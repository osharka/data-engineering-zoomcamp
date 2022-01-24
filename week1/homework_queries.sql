# Question 3

with trips as
(select 
  tr.*
from
  yellow_taxi_trips tr
  left join taxi_zones zpu 
    on tr."PULocationID" = zpu."LocationID"
  left join taxi_zones zdo 
    on tr."PULocationID" = zdo."LocationID"
)
select count(1)
from trips
where 
cast (tpep_pickup_datetime as date) = '2021-01-15'

# Question 4

with trips as
(select 
  tr.*, cast (tpep_pickup_datetime as date) as pickup_date
from
  yellow_taxi_trips tr
  left join taxi_zones zpu 
    on tr."PULocationID" = zpu."LocationID"
  left join taxi_zones zdo 
    on tr."PULocationID" = zdo."LocationID"
)
select pickup_date, max(tip_amount)
from trips
group by pickup_date
order by max(tip_amount) desc

# Question 5

#looking for id of Central Park

select *
from taxi_zones
where UPPER("Zone") like '%CENTRAL%'

#main query

with trips as
(select 
  tr.*, cast (tpep_pickup_datetime as date) as pickup_date,
  zpu."LocationID" as pu_id, zpu."Zone" as pu_zone,
  zdo."LocationID" as do_id, zdo."Zone" as do_zone
from
  yellow_taxi_trips tr
  left join taxi_zones zpu 
    on tr."PULocationID" = zpu."LocationID"
  left join taxi_zones zdo 
    on tr."DOLocationID" = zdo."LocationID"
)
select pu_id, do_id, do_zone, count(1)
from
  trips
where
  pu_id = 43 and #Central Park
  pickup_date = '2021-01-14'
group by pu_id, do_id, do_zone
order by count(1) desc

# Question 6

with trips as
(select 
  tr.*, cast (tpep_pickup_datetime as date) as pickup_date,
  zpu."LocationID" as pu_id, zpu."Zone" as pu_zone,
  zdo."LocationID" as do_id, zdo."Zone" as do_zone
from
  yellow_taxi_trips tr
  left join taxi_zones zpu 
    on tr."PULocationID" = zpu."LocationID"
  left join taxi_zones zdo 
    on tr."DOLocationID" = zdo."LocationID"
)
select pu_id, pu_zone, do_id, do_zone, sum(total_amount)/count(1)
from
  trips
group by pu_id, pu_zone, do_id, do_zone
order by sum(total_amount)/count(1) desc
