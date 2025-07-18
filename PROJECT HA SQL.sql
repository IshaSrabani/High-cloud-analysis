USE highcloud_airlines;
SELECT * FROM MAINDATA;


SELECT count(*) from maindata;

alter table maindata add column date_column date;
set sql_safe_updates=0;
update maindata set date_column = date(CONCAT(YEAR, '-', month  , '-', DAY));

   alter table maindata add column month_name varchar(20);
   update maindata set month_name= monthname(date_column);

   
   alter table maindata add column Quater varchar(2);
   update maindata set Quater = quarter(Date_column);
   
   alter table maindata add column YearMonth varchar(8);
   update maindata set YearMonth = date_format(date_column,'%Y %b');
   
   alter table maindata add column Weekday_No Int;
   update maindata set Weekday_No = IF(DAYOFWEEK(date_column) = 1, 7, DAYOFWEEK(date_column) - 1);
   
   alter table maindata add column Week_day_Name VARCHAR(9);
   UPDATE maindata
SET Week_day_Name = CASE
    WHEN DAYOFWEEK(date_column) = 1 THEN 'Sunday'
    WHEN DAYOFWEEK(date_column) = 2 THEN 'Monday'
    WHEN DAYOFWEEK(date_column) = 3 THEN 'Tuesday'
    WHEN DAYOFWEEK(date_column) = 4 THEN 'Wednesday'
    WHEN DAYOFWEEK(date_column) = 5 THEN 'Thursday'
    WHEN DAYOFWEEK(date_column) = 6 THEN 'Friday'
    ELSE 'Saturday'
END;

alter table maindata add column Financial_Month int;
UPDATE maindata
SET Financial_Month = 
    CASE 
        WHEN MONTH(date_column) >= 4 THEN MONTH(date_column) - 3
        ELSE MONTH(date_column) + 9
    END;


    ALTER TABLE maindata ADD COLUMN Financial__Quarter varchar(2);
    UPDATE maindata
SET Financial__Quarter = 
    CASE 
        WHEN month BETWEEN 1 AND 3 THEN 'Q1'
        WHEN month BETWEEN 4 AND 6 THEN 'Q2'
        WHEN month BETWEEN 7 AND 9 THEN 'Q3'
        ELSE 'Q4'
    END;
    -- "1.calcuate the following fields from the Year	Month (#)	Day  fields ( First Create a Date Field from Year , Month , Day fields)"
    select date_column, month_name, quater, yearmonth, weekday_no, week_day_name, financial_month, financial__quarter from maindata;
    
 -- 2. Find the load Factor percentage on a yearly , Quarterly , Monthly basis ( Transported passengers / Available seats)
SELECT  
    YEAR(date_column) AS Year,
    QUARTER(date_column) AS Quarter,
    MONTH(date_column) AS Month,
    sum(`# Transported Passengers`) as total_passengers,
sum(`# Available Seats`) as total_seats,
    concat(round((sum(`# Transported Passengers`) / sum(`# Available Seats`)) * 100,2),'%') as load_factor_percentage
FROM maindata
GROUP BY 
    YEAR(date_column),
    QUARTER(date_column),
    MONTH(date_column)
ORDER BY 
    Year,
    Quarter,
    Month;

-- Q3)Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)
select `Carrier Name`,
sum(`# Transported Passengers`) as total_passengers,
sum(`# Available Seats`) as total_seats,
concat(round((sum(`# Transported Passengers`) / sum(`# Available Seats`)) * 100,2),'%') as load_factor_percentage
from maindata
group by `Carrier Name`;

-- Q4 Identify Top 10 Carrier Names based passengers preference 
select `Carrier Name`,
sum(`# Transported Passengers`) as total_passengers
from maindata
group by `Carrier Name`
order by total_passengers desc
limit 10;

-- Q No. 5. Display top Routes ( from-to City) based on Number of Flights 
DESCRIBE maindata;
SELECT 
    `From - To City` AS Route,
    COUNT(*) AS Number_of_Flights
FROM maindata
GROUP BY `From - To City`
ORDER BY Number_of_Flights DESC
LIMIT 10;

-- Q No. 6. Identify the how much load factor is occupied on Weekend vs Weekdays.
SELECT
    CASE 
        WHEN `Week_day_Name` IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    SUM(`# Transported Passengers`) AS Total_Transported_Passengers,
    SUM(`# Available Seats`) AS Total_Available_Seats,
    ROUND((SUM(`# Transported Passengers`) / NULLIF(SUM(`# Available Seats`), 0)) * 100, 2) AS Load_Factor_Percentage
FROM maindata
GROUP BY Day_Type;


-- Q7 Identify number of flights based on Distance group
SELECT 
  CASE
    WHEN distance BETWEEN 0 AND 200 THEN '0-200'
    WHEN distance BETWEEN 201 AND 500 THEN '201-500'
    WHEN distance BETWEEN 501 AND 1000 THEN '501-1000'
    WHEN distance BETWEEN 1001 AND 1500 THEN '1001-1500'
    WHEN distance BETWEEN 1501 AND 2000 THEN '1501-2000'
    ELSE '2000+'
  END AS distance_group,
  COUNT(*) AS number_of_flights
FROM highcloud_airlines.maindata
GROUP BY distance_group
ORDER BY number_of_flights DESC;


-- QUESTION No. 10. provide a search capability to find the flights between Source Country,
-- Source State, Source City to Destination Country , Destination State, Destination City

SELECT *  
FROM highcloud_airlines.maindata  
WHERE `Origin Country` LIKE '%Barbados%'  
  AND `Origin City` LIKE '%Bridgetown%'  
  AND `Destination Country` LIKE '%United States%'  
  AND `Destination State` LIKE '%Florida%'  
  AND `Destination City` LIKE '%Miami%'
LIMIT 0, 1000;



