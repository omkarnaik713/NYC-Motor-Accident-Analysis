select * from tables.nyc_motor_crash
where lower(vehicle_type_1) like '%sedan%' or lower(vehicle_type_1) like 'sedan' or lower(vehicle_type_1) like 'passenger vehicle'
or lower(vehicle_type_2) like '%sedan%' or lower(vehicle_type_2) like 'sedan' or lower(vehicle_type_2) like 'passenger vehicle'
or lower(vehicle_type_3) like '%sedan%' or lower(vehicle_type_3) like 'sedan' or lower(vehicle_type_3) like 'passenger vehicle'
or lower(vehicle_type_4) like '%sedan%' or lower(vehicle_type_4) like 'sedan' or lower(vehicle_type_4) like 'passenger vehicle'
or lower(vehicle_type_5) like '%sedan%' or lower(vehicle_type_5) like 'sedan' or lower(vehicle_type_5) like 'passenger vehicle';

create table tables.nyc_crash_am select * from tables.nyc_motor_crash
where (lower(vehicle_type_1) like '%sedan%' or lower(vehicle_type_1) like 'sedan' or lower(vehicle_type_1) like 'passenger vehicle'
or lower(vehicle_type_2) like '%sedan%' or lower(vehicle_type_2) like 'sedan' or lower(vehicle_type_2) like 'passenger vehicle'
or lower(vehicle_type_3) like '%sedan%' or lower(vehicle_type_3) like 'sedan' or lower(vehicle_type_3) like 'passenger vehicle'
or lower(vehicle_type_4) like '%sedan%' or lower(vehicle_type_4) like 'sedan' or lower(vehicle_type_4) like 'passenger vehicle'
or lower(vehicle_type_5) like '%sedan%' or lower(vehicle_type_5) like 'sedan' or lower(vehicle_type_5) like 'passenger vehicle')
and crash_time like '%AM';

create table tables.nyc_crash_pm select * from tables.nyc_motor_crash
where (lower(vehicle_type_1) like '%sedan%' or lower(vehicle_type_1) like 'sedan' or lower(vehicle_type_1) like 'passenger vehicle'
or lower(vehicle_type_2) like '%sedan%' or lower(vehicle_type_2) like 'sedan' or lower(vehicle_type_2) like 'passenger vehicle'
or lower(vehicle_type_3) like '%sedan%' or lower(vehicle_type_3) like 'sedan' or lower(vehicle_type_3) like 'passenger vehicle'
or lower(vehicle_type_4) like '%sedan%' or lower(vehicle_type_4) like 'sedan' or lower(vehicle_type_4) like 'passenger vehicle'
or lower(vehicle_type_5) like '%sedan%' or lower(vehicle_type_5) like 'sedan' or lower(vehicle_type_5) like 'passenger vehicle')
and crash_time like '%PM';

create table tables.nyc_crash_am_time_category
select * ,
case 
when crash_time like '1:%' and crash_time like '%AM' then '1AM - 2AM'
when crash_time like '2:%' and crash_time like '%AM' then '2AM - 3AM'
when crash_time like '3:%' and crash_time like '%AM' then '3AM - 4AM'
when crash_time like '4:%' and crash_time like '%AM' then '4AM - 5AM'
when crash_time like '5:%' and crash_time like '%AM' then '5AM - 6AM'
when crash_time like '6:%' and crash_time like '%AM' then '6AM - 7AM'
when crash_time like '7:%' and crash_time like '%AM' then '7AM - 8AM'
when crash_time like '8:%' and crash_time like '%AM' then '8AM - 9AM'
when crash_time like '9:%' and crash_time like '%AM' then '9AM - 10AM'
when crash_time like '10:%' and crash_time like '%AM' then '10AM - 11AM'
when crash_time like '11:%' and crash_time like '%AM' then '11AM - 12PM'
when crash_time like '12:%' and crash_time like '%AM' then '12AM - 1AM'
when crash_time like '1:%' and crash_time like '%PM' then '1PM - 2PM'
when crash_time like '2:%' and crash_time like '%PM' then '2PM - 3PM'
when crash_time like '3:%' and crash_time like '%PM' then '3PM - 4PM'
when crash_time like '4:%' and crash_time like '%PM' then '4PM - 5PM'
when crash_time like '5:%' and crash_time like '%PM' then '5PM - 6PM'
when crash_time like '6:%' and crash_time like '%PM' then '6PM - 7PM'
when crash_time like '7:%' and crash_time like '%PM' then '7PM - 8PM'
when crash_time like '8:%' and crash_time like '%PM' then '8PM - 9PM'
when crash_time like '9:%' and crash_time like '%PM' then '9PM - 10PM'
when crash_time like '10:%' and crash_time like '%PM' then '10PM - 11PM'
when crash_time like '11:%' and crash_time like '%PM' then '11PM - 12AM'
when crash_time like '12:%' and crash_time like '%PM' then '12PM - 1PM'
else 'Other'
end as time_category 
from tables.nyc_motor_crash;

alter table tables.nyc_crash_am_time_category 
drop column people_injured,
drop column people_killed,
drop column pedestrian_killed,
drop column pedestrian_injured,
drop column cyclist_injured,
drop column cyclist_killed,
drop column motorist_injured,
drop column motorist_killed;

select * from tables.nyc_crash_am_time_category
where borough not like '' ;

select * from tables.nyc_crash_am_time_category
where BOROUGH like '' and location not like '';

select * from tables.nyc_filled_borough;

create table tables.nyc_crash_cleaned_data 
select * from tables.nyc_filled_borough
union 
select * from tables.nyc_crash_am_time_category
where borough not like '';

select * from tables.nyc_crash_cleaned_data;

create table tables.nyc_crash_data
select *, 
case 
when lower(borough) like '%brooklyn%' then 'Brooklyn'
when lower(borough) like '%queens%' then 'Queens'
when lower(borough) like '%bronx%' then 'Bronx'
when lower(borough) like '%manhattan' then 'Manhattan'
when lower(borough) like 'staten%' then 'Staten Island'
else 'Other'
end as Area
from tables.nyc_crash_cleaned_data;


alter table tables.nyc_crash_data 
drop column borough;

select * from tables.nyc_crash_data
where STR_TO_DATE(crash_date, '%m/%d/%Y') > '2012-12-31'
and STR_TO_DATE(crash_date, '%m/%d/%Y') < '2025-01-01';
