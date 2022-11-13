-- zadanie 1

with zad1 as(
SELECT sum([SalesAmount]) as total_sales
      ,OrderDate
  FROM [AdventureWorksDW2019].[dbo].[FactInternetSales]
  group by OrderDate)
  
select 
total_sales, 
avg(total_sales) over (order by OrderDate
rows between 3 preceding and current row), OrderDate 
from zad1
order by OrderDate


-- zadanie 2
/****** Script for SelectTopNRows command from SSMS  ******/
with zad2 as (
SELECT month([OrderDate]) month_of_year
	  ,[SalesTerritoryKey]
      ,sum([SalesAmount]) as total_sales
  FROM [AdventureWorksDW2019].[dbo].[FactInternetSales]
  where year(OrderDate) = '2011'
  group by month([OrderDate]), [SalesTerritoryKey]
  )
select * from zad2


select month_of_year, [1], [4], [6], [7], [8], [9], [10]
from 
(
  SELECT month([OrderDate]) month_of_year, SalesAmount, [SalesTerritoryKey]
  FROM [AdventureWorksDW2019].[dbo].[FactInternetSales]
  where year(OrderDate) = '2011' 

) as source_table
PIVOT
(
	sum(SalesAmount)
	For [SalesTerritoryKey] IN([1], [4], [6], [7], [8], [9], [10] )
) as PivotTable order by month_of_year


-- zadanie 3

with zad3 as(
SELECT [OrganizationKey]
      ,[DepartmentGroupKey]
      ,[Amount]
    
  FROM [AdventureWorksDW2019].[dbo].[FactFinance]
  )
select [OrganizationKey]
      ,[DepartmentGroupKey], sum([Amount]) as amount from zad3
group by rollup( [OrganizationKey]
      ,[DepartmentGroupKey]) order by OrganizationKey

-- zadanie 4

with zad3 as(
SELECT [OrganizationKey]
      ,[DepartmentGroupKey]
      ,[Amount]
    
  FROM [AdventureWorksDW2019].[dbo].[FactFinance]
  )
select [OrganizationKey]
      ,[DepartmentGroupKey], sum([Amount]) as amount from zad3
group by cube( [OrganizationKey]
      ,[DepartmentGroupKey]) order by OrganizationKey


-- zadanie 5
with zad5 as(
SELECT [OrganizationKey]
      ,sum([Amount]) as total_amount
  FROM [AdventureWorksDW2019].[dbo].[FactFinance]
  where year([Date]) = 2012
  group by OrganizationKey
)
select do.OrganizationKey, do.OrganizationName, zad5.total_amount,
PERCENT_RANK() OVER (ORDER BY total_amount) as percentile
from zad5
JOIN DimOrganization do on do.OrganizationKey = zad5.OrganizationKey
ORDER BY OrganizationKey

-- zadanie 6
with zad6 as(
SELECT [OrganizationKey]
      ,sum([Amount]) as total_amount
  FROM [AdventureWorksDW2019].[dbo].[FactFinance]
  where year([Date]) = 2012
  group by OrganizationKey
)
select do.OrganizationKey, do.OrganizationName, zad6.total_amount,
PERCENT_RANK() OVER (ORDER BY total_amount) as percentile,
STDEV(total_amount) OVER (ORDER BY do.OrganizationKey) as std
from zad6
JOIN DimOrganization do on do.OrganizationKey = zad6.OrganizationKey
ORDER BY OrganizationKey