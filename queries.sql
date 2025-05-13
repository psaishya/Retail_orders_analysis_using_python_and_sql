-- TOP 10 HIGHEST REVENUE GENERATING PRODUCTSSELECT * FROM orders.orders
SELECT product_id, SUM(sales_price) as sales 
FROM orders.orders
group by product_id
order by sales desc
limit 10;

-- TOP 5 highest selling products in each region
with temp as(
	SELECT region, product_id, sum(sales_price) as sales
	from orders.orders
	group by region,product_id)
select * from (
	select * ,
	row_number() over (partition by region order by sales desc) as rn
	from temp) A
where rn<=5;

-- Month over month growth comparision for 2022 and 2023
with temp as
	(SELECT year(order_date) as order_year, month(order_date) as order_month,sum(sales_price) as sales
	from orders.orders
	group by order_year,order_month)
select order_month,
	sum(case when order_year=2022 then sales else 0 end) as sales_2022,
	sum(case when order_year=2023 then sales else 0 end) as sales_2023
from temp
group by order_month
order by order_month

-- for each category, which month had highest sales
with temp as (
	SELECT category, month(order_date) as order_month, year(order_date) as order_year,sum(sales_price) as sales, 
	row_number() over (partition by category order by SUM(sales_price) desc) as rn 
	FROM orders.orders
	group by category,order_month,order_year
)
SELECT * from temp
where rn=1

-- which subcategory had highest growth by profit in 2023 conpared to 2022
with temp2 as 
	(with temp as(
		SELECT sub_category, year(order_date) as order_year,sum(profit) as t_profit
		from orders.orders
		group by sub_category,order_year)
	select sub_category,
	sum(case when order_year=2022 then t_profit else 0 end )as profit_2022,
	sum(case when order_year=2023 then t_profit else 0 end )as profit_2023
	from temp
	group by sub_category)
SELECT sub_category, (profit_2023-profit_2022) as profit_growth from temp2 
order by profit_growth desc
limit 1







