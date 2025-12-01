--- SQL Retail Sales Analysis ---
CREATE DATABASE sql_project_p2;

USE sql_project_p2;

select * from retail_sales;

select 
count(*) 
from retail_sales;

-- Data Cleaning --

select * from retail_sales
where transactions_id is null;

select * from retail_sales
where 
   transactions_id is null
   or
   sale_date is null
   or
   sale_time is null
   or 
   customer_id is null
   or
   gender is null
   or
   age is null
   or
   category is null
   or
   quantiy is null
   or
   price_per_unit is null
   or
   cogs is null
   or
   total_sale is null;
   
   -- Data Exploration --

-- How many sales we have?
select count(*) as total_sale from retail_sales;

-- How many unique customer we have?
select count(distinct customer_id) as total_sale from retail_sales;


-- How many unique category we have?
select distinct category from retail_sales;

-- Data Analysis --

-- Sale made on 22/11/05.

select *
from retail_sales
where sale_date = '22/11/05';

-- Retrieve where category is 'clothing' and qualty solve is more than 4 in the month of November'22 (22/11/00)?

select
    *
from retail_sales
where category = 'Clothing'
     and
     MONTH(STR_TO_DATE(sale_date, '%y/%m/%d')) = 11
     and
     YEAR(STR_TO_DATE(sale_date, '%y/%m/%d')) = 2022
     and
     quantiy >= 4;
     
-- Calculate total sale for each category?

select 
    category,
    sum(total_sale) as net_sale,
    count(*) as total_orders
from retail_sales
group by 1;

-- Find the average age of customers who purchase item from 'Beauty' category?

select
    round(avg(age), 2) as avg_age
from retail_sales
where category = 'Beauty';

-- All the transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000;

-- Find total numbers of transactions made by each gender in each category.

select
    category,
    gender,
    count(*) as total_trans
from retail_sales
group 
     by 
     category,
     gender
order by 1;

-- Calculate the average sales of each month. Find out best selling month in each year?

select 
     year(sale_date),
     month(sale_date),
     avg(total_sale) as avg_sale,
     rank() over(partition by year(sale_date) order by avg(total_sale) desc) as rank_by_sales
from retail_sales
group by 1, 2;

-- Find the top 5 customers based on the highest total sales.

select 
     customer_id,
     sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

-- Find the number of unique customers who purchase items from each category.

select 
     category,
     count(distinct customer_id) as count_unique_cust
from retail_sales
group by category;

-- Create each shift and numbers of orders (ex. Morning < 12, Afternoon between 12 & 17 and Evening > 17)

with hourly_sales
as
(
select *,
   case
      when extract(hour from sale_time) < 12 then 'Morning'
      when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
      else 'Evening'
	end as shift
 from retail_sales
)
select
     shift,
     count(*) as total_orders
from hourly_sales
group by shift;

-- End of Project --

   