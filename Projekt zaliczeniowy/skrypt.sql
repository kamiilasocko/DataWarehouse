-- ZAPYTANIA - ETL

CREATE DATABASE projekt_zal_staging;

CREATE DATABASE projekt_zal_prod;


-- db.projekt_zal_prod
CREATE TABLE [dbo].[DIMCustomers](
	[id_key] [int] IDENTITY(1,1),
	[id] [smallint] NULL,
	[first_name] [varchar](50) NULL,
	[last_name] [varchar](50) NULL,
	[street] [varchar](50) NULL,
	[city] [varchar](50) NULL,
	[state] [varchar](50) NULL,
	[country] [varchar](50) NULL,
	[phone] [varchar](50) NULL,
	[email] [varchar](50) NULL,
	eff_start_date date,
	eff_end_date date
);


-- db.projekt_zal_staging
-- update Customers 
-- zmieniamy numer tel w tabeli staging i zapisuje sie on jako nowy wiersz w tabeli DIMCustomers

  update Customers
  set phone = '111-123-8888'
  where id = 2


-- db.projekt_zal_prod

CREATE TABLE [dbo].[DIMCarriers](
	[id_key] [int] IDENTITY(1,1),
	[carrier_id] [int] NULL,
	[carrier_name] [varchar](4) NULL,
	[address] [varchar](48) NULL,
	[tax_id] [int] NULL,
	[contact_person] [varchar](19) NULL,
	eff_start_date date,
	eff_end_date date
)

-- db.projekt_zal_staging
-- update Carriers 
-- zmieniamy tax_id w tabeli staging i zapisuje sie on jako nowy wiersz w tabeli DIMCarriers

  update Carriers
  set carrier_name = 'Bolt'
  where carrier_id = 2



  -- db.projekt_zal_prod
  -- DIMDate
  CREATE TABLE [dbo].[DIMDate]
(
    [DateKey] INT NOT NULL PRIMARY KEY, 
    [Date] DATE NOT NULL,
	[Day] TINYINT NOT NULL,
	[Quarter] TINYINT NOT NULL,
	[Year] INT NOT NULL,
	[Month] CHAR(7) NOT NULL,
	[Week] TINYINT NOT NULL,
)    


DECLARE @StartDate DATE = '2005-01-01'
DECLARE @EndDate DATE = DATEADD(Day, -1, DATEADD(YEAR, 10, @StartDate));


WHILE @StartDate < @EndDate
BEGIN
   INSERT INTO [dbo].[DIMDate] (

	[DateKey], 
	[Date],
	[Day],
	[Quarter],
	[Year],
	[Month],
	[Week]
	)
	SELECT [DateKey] = YEAR(@StartDate) * 10000 + MONTH(@StartDate) * 100 + DAY(@StartDate),
	[Date] = @StartDate, 
	[Day] = DATEPART(day, @StartDate),
	[Quarter] = DATEPART(Quarter, @StartDate),
	[Year] = DATEPART(YEAR, @StartDate),
	[Month] = DATEPART(MONTH, @StartDate),
	[Week] = DATEPART(WEEK, @StartDate)


	SET @StartDate = DATEADD(DD, 1, @StartDate)

END

select * from [dbo].[DIMDate]




-- ZAPYTANIA ANALITYCZNE


-- œrednia krocz¹ca
with monthly_sales as(
SELECT sum(amount) as total_sales
	  ,month(date) month_sales
  FROM [dbo].[FactSales]
  group by month(date)
)

select 
total_sales, 
avg(total_sales) over (order by month_sales
rows between 3 preceding and current row) moving_avg_sales, month_sales 
from monthly_sales
order by month_sales;


-- lata z najlepsza sprzeda¿¹

-- bez uzycia DIMDate
select rank() over( order by sum(amount) desc) as ranking
	,year(date) as year
	,sum(amount) as total_sales
	
from [dbo].[FactSales] f
group by year(date)


select PERCENT_RANK() over( order by sum(amount) desc) as ranking
	,year(date) as year
	,sum(amount) as total_sales
from [dbo].[FactSales] f
group by year(date)

-- z DIMDate
select rank() over( order by sum(f.amount) desc) as ranking
	,d.Year
	,sum(f.amount) as total_sales
from [dbo].[FactSales] f
left join DIMDate d on  f.DateKey = d.DateKey
group by d.Year


select PERCENT_RANK() over( order by sum(f.amount) desc) as ranking
	,d.Year
	,sum(amount) as total_sales
from [dbo].[FactSales] f
left join DIMDate d on  f.DateKey = d.DateKey
group by d.Year


-- porównanie wielkoœci sprzedazy w latach przez danych dostawcow
-- group by rollup,

select dc.carrier_name 
		,d.Year
		,sum(amount) as total_sales
		,stdev(sum(amount)) over (order by sum(amount) desc) as std
from [dbo].[FactSales] f
left join DIMCarriers dc on f.carrier_id_key = dc.id_key
left join DIMDate d on  f.DateKey = d.DateKey
group by rollup(carrier_name, d.Year)

-- ranking sprzedazy w panstwach i ilosc ich klientow

select rank() over( order by sum(amount) desc) as ranking
	,dc.country as country
	,sum(f.amount) as total_sales
	,count(distinct dc.id) count_of_customers
from [dbo].[FactSales] f
left join DIMCustomers dc on f.customer_id_key = dc.id_key
group by dc.country






