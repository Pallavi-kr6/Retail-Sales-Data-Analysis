 
SELECT current_database();
SELECT 
    COUNT(*) 
FROM retailSales;

-- Data Cleaning
SELECT * FROM retailSales
WHERE transactions_id IS NULL;

SELECT * FROM retailSales
WHERE sale_date IS NULL;

SELECT * FROM retailSales
WHERE sale_time IS NULL;

SELECT * FROM retailSales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retailSales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retailSales;

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as totalSale FROM retailSales;



SELECT DISTINCT category FROM retailSales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retailSales where sale_date='2022-11-05';
-- Q.2 Write a SQL query to retrieve all 
--transactions where the category is 'Clothing'
--and the quantity sold is more than 10 in the month 
--of Nov-2022
SELECT category,
       SUM(quantiy) AS quant,
       TO_CHAR(sale_date,'FMMonth') AS sale_month
FROM retailSales
WHERE category = 'clothing'
  AND TO_CHAR(sale_date,'FMMonth') = '2022-11'
GROUP BY category, TO_CHAR(sale_date,'FMMonth')
HAVING SUM(quantiy) >= 0;
select * from retailSales;
-- Q.3 Write a SQL query to calculate the total
--sales (total_sale) for each category.
select category,
sum(total_sale) as total_sales
from retailsales
group by category;
-- Q.4 Write a SQL query to find the average 
--age of customers who purchased items from the 
--'Beauty' category.
SELECT  
       AVG("age")
FROM "retailsales"
WHERE "category" = 'beauty';
 
 
-- Q.5 Write a SQL query to find all transactions 
--where the total_sale is greater than 1000.
select transactions_id,total_sale
from retailsales
where total_sale>1000
group by transactions_id,total_sale; 
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender,count(transactions_id) as total_transaction 
from retailsales group by category,gender;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
 select 
 year,month,avg_Sale
 from(
select extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sale,
rank() over(partition by extract(year from sale_date) order by avg(total_sale)desc)as rank
from retailsales 
 group by 1,2
 ) as t1
 where rank=1; 
-- Q.8 Write a SQL query to find 
--the top 5 customers based on the highest total sales 
select customer_id,
sum(total_sale) as total_Sales
from retailsales
group by 1
order by 2 desc
limit 5;
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS cust_count
FROM retailsales
GROUP BY category;


-- Q.10 Write a SQL query to create each
--shift and number of orders
--(Example Morning <=12, Afternoon Between 12 & 17, 
--Evening >17)
WITH hourly_sale AS (
    SELECT *,
           CASE
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retailsales
)
SELECT 
    shift,
    COUNT(*) AS number_of_orders
FROM hourly_sale
GROUP BY shift
ORDER BY shift;

