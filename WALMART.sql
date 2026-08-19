SELECT * FROM walmart_cleaned;
 
 SELECT COUNT(DISTINCT Branch) 
 FROM walmart_cleaned;
 
 SELECT MAX(quantity) FROM walmart_cleaned; --- DONE
 
-- Business Problem Q1: Find different payment methods, number of transactions, and quantity sold by payment method
-- This result use for POWERBI 
 
 SELECT 
 payment_method, 
 COUNT(*) as no_payments,
 SUM(quantity) AS num_qty_sold
 FROM walmart_cleaned
 GROUP BY payment_method;
 
 -- Project Question #2: Identify the highest-rated category in each branch
-- Display the branch, category, and avg rating
SELECT *
FROM (
SELECT 
	 branch,
      category,
 AVG(rating) as AVG_rating,
 RANK() OVER(PARTITION  BY branch ORDER BY AVG(rating) DESC) as rnk
FROM walmart_cleaned
GROUP BY branch,category
) as ranked_categories
WHERE rnk = 1;

-- Q3: Identify the busiest day for each branch based on the number of transactions

SELECT branch, day_name, no_transactions, rnk
FROM (
    SELECT 
        branch,
        DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart_cleaned
    GROUP BY branch, day_name
) AS ranked
WHERE rnk = 1;

-- Q4: Calculate the total quantity of items sold per payment method
 
 SELECT payment_method, 
 SUM(quantity) as qty_sold
 FROM walmart_cleaned
 GROUP BY payment_method;
 -- We can use this in POWER BI --
 
 -- Q5: Determine the average, minimum, and maximum rating of categories for each city
 
 SELECT city,category,
 MAX(rating) as max_rating,
 MIN(rating) as min_rating,
 AVG(rating) as avg_rating
 FROM walmart_cleaned
 GROUP BY category , city; 
 -- Perhaps help for POWER BI--
 
 
 -- Q6: Calculate the total profit for each category
 
 SELECT category,
 sum(unit_price * quantity * profit_margin) as total_profit
 FROM walmart_cleaned
 GROUP BY category
 ORDER BY total_profit DESC; 
 
 -- Q7: Determine the most common payment method for each branch

WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart_cleaned
    GROUP BY branch, payment_method
)
SELECT branch, payment_method AS preferred_payment_method
FROM cte
WHERE rnk = 1;
-- finally done --

 







