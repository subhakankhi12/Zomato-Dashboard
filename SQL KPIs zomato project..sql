SELECT * FROM restaurants_clean;
-- KPI1
select* from countries;
select r.restaurantName, r.countryCode, c.country  
from restaurants r join countries c
on c.country_code = r.CountryCode;

-- KPI2
CREATE TABLE calendar_table AS
SELECT DISTINCT
    opening_date                                                    AS datekey,
    YEAR(opening_date)                                              AS year,
    MONTH(opening_date)                                             AS monthno,
    MONTHNAME(opening_date)                                         AS monthfullname,
    CONCAT('Q', QUARTER(opening_date))                              AS quarter,
    DATE_FORMAT(opening_date, '%Y-%b')                              AS yearmonth,
    WEEKDAY(opening_date) + 1                                       AS weekdayno,
    DAYNAME(opening_date)                                           AS weekdayname,
    CONCAT('FM', ((MONTH(opening_date) + 8) % 12) + 1)              AS financialmonth,
    CONCAT('FQ', CEIL((((MONTH(opening_date) + 8) % 12) + 1) / 3))  AS financialquarter
FROM restaurants_clean
WHERE opening_date IS NOT NULL
ORDER BY datekey;
SELECT * FROM calendar_table LIMIT 20;

-- KPI3 (restaurants by country)
select country,count(*) as total_restaurants
from restaurants_clean
group by country
order by total_restaurants desc;

-- restaurants by city
select city,count(*) as total_restaurants
from restaurants_clean
group by city
order by total_restaurants desc limit 20;

-- KPI4: year wise
select year(opening_date) as opening_year,
count(*) as total_restaurants
from restaurants_clean
group by opening_year
order by opening_year;

-- KPI4: year + quarter wise
select year(opening_date) as opening_year,
concat('Q',Quarter(opening_date)) as opening_quarter,
count(*) as total_restaurants
from restaurants_clean
group by opening_year,opening_quarter
order by opening_year, opening_quarter;

-- KPI4: year + month wise
select year(opening_date) as opening_year,
month(opening_date) as month_no,
monthname(opening_date) as month_name,
count(*) as total_restaurants
from restaurants_clean
group by opening_year, month_no, month_name
order by opening_year, month_no;

-- KPI5
SELECT rating, COUNT(*) AS total_restaurants
FROM restaurants_clean
WHERE is_rated = 1
GROUP BY rating
ORDER BY rating DESC;

-- KPI6 
SELECT
    CASE
        WHEN avg_cost_for_two < 200 THEN '0-200'
        WHEN avg_cost_for_two < 500 THEN '200-500'
        WHEN avg_cost_for_two < 1000 THEN '500-1000'
        WHEN avg_cost_for_two < 2000 THEN '1000-2000'
        WHEN avg_cost_for_two < 5000 THEN '2000-5000'
        ELSE '5000+'
    END AS price_bucket,
    COUNT(*) AS total_restaurants
FROM restaurants_clean
WHERE avg_cost_for_two IS NOT NULL
GROUP BY price_bucket
ORDER BY MIN(avg_cost_for_two);

-- KPI7
SELECT has_table_booking,
       COUNT(*) AS total_restaurants,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM restaurants_clean
GROUP BY has_table_booking;

-- KPI8
select has_online_delivery,
count(*) as total_restaurants,
ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM restaurants_clean
GROUP BY has_online_delivery;



