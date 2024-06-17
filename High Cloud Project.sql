create database Highcloud_Project;
use Highcloud_Project;
select count(*) from maindata;
select * from maindata;


## Q1
CREATE TABLE calendar (
    Datekey DATE,
    year INT,
    month INT,
    day INT,
    week INT,
    monthname VARCHAR(50),
    weekday INT,
    yearmonth VARCHAR(50),
    dayname VARCHAR(50),
    Quarters VARCHAR(50),
    Financial_Months VARCHAR(50),
    Financial_Quarters VARCHAR(50));

-- Add the new date column
ALTER TABLE maindata
ADD COLUMN date_column DATE;

UPDATE maindata
SET date_column = DATE(CONCAT(year, '-', 
                              LPAD(month, 2, '0'), '-', 
                              LPAD(day, 2, '0')));


INSERT INTO calendar (datekey, year, month, day, week, monthname, weekday, yearmonth, dayname, Quarters, Financial_months, Financial_Quarters)
SELECT 
    Date_Column AS Datekey,
    YEAR(Date_Column) AS year,
    MONTH(Date_Column) AS month,
    DAY(Date_Column) AS day,
    week(Date_Column) as week,
    monthname(Date_Column) as monthname,
    DAYOFWEEK(Date_Column) AS weekday,
    concat(year(Date_Column), '-', monthname(Date_Column)) as yearmonth,
    dayname(Date_Column) as dayname,

case when monthname(Date_Column) in ('January', 'February', 'March') then 'Q1'
     when monthname(Date_Column) in ('April', 'May', 'June') then 'Q2'
     when monthname(Date_Column) in ('July', 'August', 'September') then 'Q3'
     else 'Q4' end as quarters,

case 
     when monthname(Date_Column) =  'January' then 'FM10'
     when monthname(Date_Column)= 'February' then 'FM11'
     when monthname(Date_Column)= 'March' then 'FM12'
     when monthname(Date_Column)= 'April' then 'FM1'  
     when monthname(Date_Column)= 'May' then 'FM2'                                                             
     when monthname(Date_Column) = 'June' then 'FM3'
     when monthname(Date_Column) = 'July' then 'FM4'
     when monthname(Date_Column) = 'August' then 'FM5'
     when monthname(Date_Column) = 'September' then 'FM6'
     when monthname(Date_Column) = 'October' then 'FM7'
     when monthname(Date_Column) = 'November' then 'FM8'
     when monthname(Date_Column) = 'December' then 'FM9'
end Financial_months,

case when monthname(Date_Column) in ('January', 'February', 'March') then 'FQ4'
     when monthname(Date_Column) in ('April', 'May', 'June') then 'FQ1'
     when monthname(Date_Column) in ('July', 'August', 'September') then 'FQ2'
 ELSE 'FQ3' end as financial_Quarters  from  maindata;
 
 SELECT * FROM highcloud_project.calendar;
 
 

 ## Q2 
 --  load Factor percentage on yearly basis

SELECT Year,
       ROUND(AVG(Transported_Passengers) / AVG(Available_Seats) * 100, 2) AS Load_Factor_Percentage
FROM maindata
GROUP BY Year;

-- load Factor percentage on quarterly basis

SELECT Quarter,
       ROUND(AVG(Transported_Passengers) / AVG(Available_Seats) * 100, 2) AS Load_Factor_Percentage
FROM (SELECT CEILING(Month / 3) AS Quarter, Transported_Passengers, Available_Seats
      FROM maindata) AS Quarterly
GROUP BY Quarter
ORDER BY Quarter ASC;
 
 -- load Factor percentage on monthly basis
SELECT Month,
       ROUND(AVG(Transported_Passengers) / AVG(Available_Seats) * 100, 2) AS Load_Factor_Percentage
FROM maindata
GROUP BY Month;




-- Carrier name wise Load_Factor_Percentage

SELECT carrier_name,
       IFNULL(CONCAT(ROUND(AVG(Transported_Passengers/Available_Seats)*100,2),"%"),0) AS Load_Factor_Percentage
FROM maindata
GROUP BY Carrier_name
ORDER BY Load_Factor_Percentage DESC LIMIT 10;



-- Top 10 Carriers based on passenger preference
SELECT Carrier_name,
       COUNT(Transported_Passengers) AS Total_Passengers
FROM maindata
GROUP BY Carrier_name
ORDER BY Total_Passengers DESC LIMIT 10;




-- Top 10 Routes Based on No.of Flights
SELECT `From _To_city`,
       SUM(departures_performed) AS flights_count
FROM maindata
GROUP BY `From _To_city`
ORDER BY flights_count DESC LIMIT 10;




  -- Load Factor Percentage on Weekend & Weekdays
SELECT
  CASE
    WHEN dayofweek(date_column) IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_category,
  CONCAT(ROUND(AVG(Transported_Passengers/Available_Seats)*100,2),"%") AS Load_Factor_Percentage
FROM maindata
GROUP BY day_category;



-- Count of flights based on distance groups
SELECT Distance_interval, COUNT(Departures_Performed) AS Total_flights
FROM maindata
right join distance_groups ON maindata.Distance_group_ID = distance_groups.distance_group_id
GROUP BY Distance_interval
ORDER BY Total_flights DESC;



