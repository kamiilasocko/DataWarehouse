-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-10-14 12:17:36.561

-- tables
-- Table: Date
CREATE TABLE Date (
    ID int  NOT NULL,
    Day int  NOT NULL,
    Month int  NOT NULL,
    Year int  NOT NULL,
    CONSTRAINT Date_pk PRIMARY KEY  (ID)
);

-- Table: MiniDimProduct
CREATE TABLE MiniDimProduct (
    ProductID int  NOT NULL,
    Name varchar(50)  NOT NULL,
    CONSTRAINT MiniDimProduct_pk PRIMARY KEY  (ProductID)
);

-- Table: Product
CREATE TABLE Product (
    ID int  NOT NULL,
    Brand varchar(50)  NOT NULL,
    CONSTRAINT Product_pk PRIMARY KEY  (ID)
);

-- Table: State
CREATE TABLE State (
    ID int  NOT NULL,
    ProductID int  NOT NULL,
    DateID int  NOT NULL,
    Count int  NOT NULL,
    CONSTRAINT State_pk PRIMARY KEY  (ID)
);

-- Table: Warehouse
CREATE TABLE Warehouse (
    ID int  NOT NULL,
    StateID int  NOT NULL,
    Address varchar(50)  NOT NULL,
    Country varchar(50)  NOT NULL,
    CONSTRAINT Warehouse_pk PRIMARY KEY  (ID)
);

-- foreign keys
-- Reference: Product_MiniDimProduct (table: Product)
ALTER TABLE Product ADD CONSTRAINT Product_MiniDimProduct
    FOREIGN KEY (ID)
    REFERENCES MiniDimProduct (ProductID);

-- Reference: State_Date (table: State)
ALTER TABLE State ADD CONSTRAINT State_Date
    FOREIGN KEY (DateID)
    REFERENCES Date (ID);

-- Reference: State_Product (table: State)
ALTER TABLE State ADD CONSTRAINT State_Product
    FOREIGN KEY (ProductID)
    REFERENCES Product (ID);

-- Reference: Warehouse_State (table: Warehouse)
ALTER TABLE Warehouse ADD CONSTRAINT Warehouse_State
    FOREIGN KEY (StateID)
    REFERENCES State (ID);

-- End of file.

