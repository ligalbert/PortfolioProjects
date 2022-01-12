--Analysis of revenues and parking for two hotels in the last 3 years 
-- Union of Hotel tables for 3 years 
WITH hotels AS(
SELECT * FROM Project..['2018$']
UNION
SELECT * FROM Project..['2019$']
UNION
SELECT * FROM Project..['2020$'])

SELECT  * from hotels
JOIN market_segment$
ON hotels.market_segment = market_segment$.market_segment
LEFT JOIN 
meal_cost$ ON meal_cost$.meal = hotels.meal

-- 

