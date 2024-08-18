create database retail;

-- Data Exploration & Cleaning 

-- 1 Record Count: Determine the total number of records in the dataset.

select count(transactions_id) from retail_sales;

-- 2. Customer Count: Find out how many unique customers are in the dataset.

select count(distinct customer_id) from retail_sales;

-- 3. Category Count: Identify all unique product categories in the dataset.

select count(distinct category) from retail_sales;

--  Data Analysis & Findings 

-- Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select * from retail_sales
where sale_date =  '2022-11-05';


-- Q2.Write a SQL query to retrieve all transactions where 
-- the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select * from retail_sales
where category = "clothing"
and sale_date between '2022-11-01' AND '2022-11-30'
and quantiy>=4;

-- Q3.Write a SQL query to calculate the total sales (total_sale) for each category.:


select sum(total_sale) as total_sales 
, category from retail_sales
group by category;

-- Q4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

select round(avg(age),0) as avg_age , category 
from retail_sales where category = "beauty";

-- Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000

select * from retail_sales
where total_sale>1000;

-- Q6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

select count(transactions_id) as total_transactions , gender, category
from retail_sales 
group by gender,category;

-- Q7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT 
       year,
       month,
       avg_sale
FROM 
(    
    SELECT 
        year(sale_date) AS year,
        month(sale_date)AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY year(sale_date)  ORDER BY AVG(total_sale) DESC) AS rank_
    FROM retail_sales
    GROUP BY year, month
) AS t1
WHERE rank_ = 1;

-- Q8.Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT CUSTOMER_ID , SUM(total_sale) as total_sales
from retail_sales group by customer_id order by total_sales desc limit 5;

-- Q9.Write a SQL query to find the number of unique customers who purchased items from each category

select category ,count(distinct(customer_id))as customer_id
from retail_sales group by category;

-- Q10.Write a SQL query to create each shift and number of
--  orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with hourly_sale 
as (
select * , case
when hour(sale_time)  <12 then "morning"
when hour(sale_time) between 12 and 17 then "afternoon"
else "evening"
end as shift
from retail_sales)

select count(*) as total_orders , shift from hourly_sale 
group by shift;