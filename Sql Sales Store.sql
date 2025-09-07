

SELECT count(*) FROM hen.sales_store_updated_allign_with_video;

Select * from hen.sales_store_updated_allign_with_video;

Describe hen.sales_store_updated_allign_with_video;

-- Data cleaning

alter table hen.sales_store_updated_allign_with_video
rename column quantiy to quantity;

alter table hen.sales_store_updated_allign_with_video
rename column prce to price;

-- checking duplicates

with  duplicate_check as (
Select  transaction_id	,
customer_id	,customer_name	,customer_age	,
gender,	product_id,	product_name	,product_category,	
quantity,	price,	payment_mode,	purchase_date	,time_of_purchase,	status , count(*) as total_count
from hen.sales_store_updated_allign_with_video
group by transaction_id	,
customer_id	,customer_name	,customer_age	,
gender,	product_id,	product_name	,product_category,	
quantity,	price,	payment_mode,	purchase_date	,time_of_purchase,	status
having total_count > 1
)

delete from hen.sales_store_updated_allign_with_video 
where transaction_id in (
     select transaction_id from duplicate_check where total_count > 1 );

-- checking null

select * from hen.sales_store_updated_allign_with_video 
where transaction_id is null 
or customer_id is null or 
customer_name is null or 
customer_age is null or
gender is null
or	product_id is null
or	product_name is null	
or product_category is null	
or quantity is null
or	price is null
or	payment_mode is null
or	purchase_date	is null
or time_of_purchase is null
or	status is null;


Select distinct gender from hen.sales_store_updated_allign_with_video;

update hen.sales_store_updated_allign_with_video
set gender = "Female"
where gender = "F";

update hen.sales_store_updated_allign_with_video
set gender = "Male"
where gender = "M";


Select distinct payment_mode
 from hen.sales_store_updated_allign_with_video;

update hen.sales_store_updated_allign_with_video
set payment_mode = "Credit Card"
where payment_mode = "CC";


-- top 5 selling product name by qty
select product_name, sum(quantity) as qty
from hen.sales_store_updated_allign_with_video
group by product_name
order by qty desc
limit 5;

select product_name, sum(quantity) as qty
from hen.sales_store_updated_allign_with_video
where status = 'delivered'
group by product_name
order by qty desc
limit 5;



-- which product is mot canceled

select product_name, count(*) as qty
from hen.sales_store_updated_allign_with_video
where status = 'cancelled'
group by product_name
order by qty desc
limit 5;


-- what time of the day highest number of purchase

SELECT 
    CASE
        WHEN HOUR(STR_TO_DATE(time_of_purchase, '%H:%i:%s')) BETWEEN 0 AND 5  THEN 'Night'
        WHEN HOUR(STR_TO_DATE(time_of_purchase, '%H:%i:%s')) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(STR_TO_DATE(time_of_purchase, '%H:%i:%s')) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(STR_TO_DATE(time_of_purchase, '%H:%i:%s')) BETWEEN 18 AND 23 THEN 'Evening'
    END AS time_of_day,
    COUNT(*) AS total_purchases
FROM hen.sales_store_updated_allign_with_video
GROUP BY time_of_day
ORDER BY total_purchases DESC;


-- top 5 spending cx

Select customer_name , sum(quantity * price) as total_sales
from hen.sales_store_updated_allign_with_video
group by customer_name
order  by total_sales desc
limit 5;

-- category wise sales
Select product_category
 , sum(quantity * price) as total_sales
from hen.sales_store_updated_allign_with_video
group by product_category

order  by total_sales desc;


-- what is the return /cancelaation rate per category

select product_category,
count(case when status ='cancelled' then 1 end)/count(*) * 100 as cnret
from hen.sales_store_updated_allign_with_video
group by product_category;

-- most frquesnt payment_mode
Select payment_mode, count(*) 
from hen.sales_store_updated_allign_with_video
group by payment_mode
order by count(*)  desc;


 