-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-10-14 12:05:49.17

-- tables
-- Table: ClientDimTable
CREATE TABLE ClientDimTable (
    ClientID int  NOT NULL,
    Name varchar(50)  NOT NULL,
    Surname varchar(50)  NOT NULL,
    PhoneNumber int  NOT NULL,
    Address varchar(50)  NOT NULL,
    CONSTRAINT ClientDimTable_pk PRIMARY KEY  (ClientID)
);

-- Table: CourierCompanyDimTable
CREATE TABLE CourierCompanyDimTable (
    NIP int  NOT NULL,
    Address varchar(50)  NOT NULL,
    Name varchar(50)  NOT NULL,
    CONSTRAINT CourierCompanyDimTable_pk PRIMARY KEY  (NIP)
);

-- Table: DateDim
CREATE TABLE DateDim (
    DateID int  NOT NULL,
    FullDate date  NOT NULL,
    Day int  NOT NULL,
    Month int  NOT NULL,
    Year int  NOT NULL,
    CONSTRAINT DateDim_pk PRIMARY KEY  (DateID)
);

-- Table: ProductDimTable
CREATE TABLE ProductDimTable (
    ISBN int  NOT NULL,
    Publisher varchar(50)  NOT NULL,
    Titile varchar(50)  NOT NULL,
    Author varchar(50)  NOT NULL,
    NumberOfPages int  NOT NULL,
    CONSTRAINT ProductDimTable_pk PRIMARY KEY  (ISBN)
);

-- Table: SalesFactTable
CREATE TABLE SalesFactTable (
    SalesID int  NOT NULL,
    DateID int  NOT NULL,
    ClientID int  NOT NULL,
    CourierCompanyID int  NOT NULL,
    ProductID int  NOT NULL,
    Amount int  NOT NULL,
    CONSTRAINT SalesFactTable_pk PRIMARY KEY  (SalesID)
);

-- foreign keys
-- Reference: FactTable_ClientDimTable (table: SalesFactTable)
ALTER TABLE SalesFactTable ADD CONSTRAINT FactTable_ClientDimTable
    FOREIGN KEY (ClientID)
    REFERENCES ClientDimTable (ClientID);

-- Reference: FactTable_CourierCompanyDimTable (table: SalesFactTable)
ALTER TABLE SalesFactTable ADD CONSTRAINT FactTable_CourierCompanyDimTable
    FOREIGN KEY (CourierCompanyID)
    REFERENCES CourierCompanyDimTable (NIP);

-- Reference: FactTable_ProductDimTable (table: SalesFactTable)
ALTER TABLE SalesFactTable ADD CONSTRAINT FactTable_ProductDimTable
    FOREIGN KEY (ProductID)
    REFERENCES ProductDimTable (ISBN);

-- Reference: SalesFactTable_DateDim (table: SalesFactTable)
ALTER TABLE SalesFactTable ADD CONSTRAINT SalesFactTable_DateDim
    FOREIGN KEY (DateID)
    REFERENCES DateDim (DateID);

-- End of file.

