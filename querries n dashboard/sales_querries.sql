select * from sales_cleaned;


# calculating year with highest sales and comparing with expsales

select yearorders, round(sum(sales), 2) as totalsales,
round(sum(expsales),2) as expsales from sales_cleaned
group by yearorders
order by 3 desc;

# ANALYZING THE YEAR 2004 AS IT WAS THE YEAR WITH HIGHEST SALES

# PRODUCT WITH HIGHEST SALES

select productline, round(sum(sales), 2) as total_sales
from sales_cleaned
where yearorders = 2004
group by 1
order by 2 desc;

# MOST ACTIVE COUNTRY AND CITY IN THAT COUNTRY IN 2004

select country, count(country) as counts
from sales_cleaned
where yearorders = 2004
group by 1
order by 2 desc
LIMIT 10;

select city, count(city) as counts
from sales_cleaned
where yearorders = 2004 and country = "USA"
group by 1
order by 2 desc
limit 10;

# WHICH MONTH THEY MADE THE HIGHEST SALES

select monthordered, round(sum(sales), 2) as total_sales
from sales_cleaned
where yearorders = 2004
group by 1
order by 2 desc;

# MOST ACTIVE CUSTOMER IN 2004 AND WHAT THEY BOUGHT THE MOST

select customername, count(customername) as count
from sales_cleaned
where yearorders = 2004
group by 1
order by 2 desc
limit 10;

select productline, count(productline) as counts
from sales_cleaned
where yearorders = 2004 and customername = "Euro Shopping Channel"
group by 1
order by 2 desc;