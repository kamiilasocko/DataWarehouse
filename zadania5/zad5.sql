CREATE CLUSTERED INDEX idx_customer_state ON [dbo].[DIMCustomers] ([state])

IF EXISTS
(
  SELECT 1 FROM sys.indexes
  WHERE name='idx_customer_state' AND object_id = OBJECT_ID('[dbo].[DIMCustomers]')
)
BEGIN
     PRINT 'Clustered index "idx_customer_state" exists'
END






CREATE VIEW carrier_sales WITH SCHEMABINDING AS 
SELECT 
        ft.[order_details_id],
        ft.[order_id],
        ft.[pizza_id],
        ft.[quantity],
        ft.[date],
        ft.[time],
        c.[carrier_name],
        c.[address],
        c.[tax_id],
        c.[contact_person]
    FROM [dbo].[FACTOrdersCustomers] ft
    JOIN [dbo].[DIMCarrier] c
    ON c.[key] = ft.[carrier_id]



CREATE UNIQUE CLUSTERED INDEX idx_carrier_sales ON carrier_sales (
       [order_details_id]
      ,[order_id]
      ,[pizza_id]
      ,[quantity]
      ,[date]
      ,[time]
      ,[carrier_name]
      ,[address]
      ,[tax_id]
      ,[contact_person]
)



IF EXISTS
(
  SELECT 1 FROM sys.indexes
  WHERE name='idx_carrier_sales' AND object_id = OBJECT_ID('carrier_sales')
)
BEGIN
     PRINT 'Clustered unique index "idx_carrier_sales" exists'
END