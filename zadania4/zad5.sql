
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


DECLARE @StartDate DATE = '2015-01-01'
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
