-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-10-11 20:16:26.088

-- tables
-- Table: Category
CREATE TABLE Category (
    ID int  NOT NULL,
    CategoryName int  NOT NULL,
    CONSTRAINT Category_pk PRIMARY KEY  (ID)
);

-- Table: Client
CREATE TABLE Client (
    NIP int  NOT NULL,
    Name varchar(50)  NOT NULL,
    Address varchar(50)  NOT NULL,
    CONSTRAINT Client_pk PRIMARY KEY  (NIP)
);

-- Table: Date
CREATE TABLE Date (
    ID int  NOT NULL,
    Hour int  NOT NULL,
    Day int  NOT NULL,
    Month int  NOT NULL,
    FullDate date  NOT NULL,
    CONSTRAINT Date_pk PRIMARY KEY  (ID)
);

-- Table: Fruit
CREATE TABLE Fruit (
    ID int  NOT NULL,
    Name varchar(50)  NOT NULL,
    Price int  NOT NULL,
    Category_ID int  NOT NULL,
    CONSTRAINT Fruit_pk PRIMARY KEY  (ID)
);

-- Table: OrderDetails
CREATE TABLE OrderDetails (
    ID int  NOT NULL,
    Place varchar(50)  NOT NULL,
    OrderAmount int  NOT NULL,
    FruitCount int  NOT NULL,
    CONSTRAINT OrderDetails_pk PRIMARY KEY  (ID)
);

-- Table: Sales
CREATE TABLE Sales (
    SalesID int  NOT NULL,
    Fruit_ID int  NOT NULL,
    Client_NIP int  NOT NULL,
    OrderDetails_ID int  NOT NULL,
    Date_ID int  NOT NULL,
    CONSTRAINT Sales_pk PRIMARY KEY  (SalesID)
);

-- foreign keys
-- Reference: Fruit_Category (table: Fruit)
ALTER TABLE Fruit ADD CONSTRAINT Fruit_Category
    FOREIGN KEY (Category_ID)
    REFERENCES Category (ID);

-- Reference: Sales_Client (table: Sales)
ALTER TABLE Sales ADD CONSTRAINT Sales_Client
    FOREIGN KEY (Client_NIP)
    REFERENCES Client (NIP);

-- Reference: Sales_Date (table: Sales)
ALTER TABLE Sales ADD CONSTRAINT Sales_Date
    FOREIGN KEY (Date_ID)
    REFERENCES Date (ID);

-- Reference: Sales_Fruit (table: Sales)
ALTER TABLE Sales ADD CONSTRAINT Sales_Fruit
    FOREIGN KEY (Fruit_ID)
    REFERENCES Fruit (ID);

-- Reference: Sales_OrderDetails (table: Sales)
ALTER TABLE Sales ADD CONSTRAINT Sales_OrderDetails
    FOREIGN KEY (OrderDetails_ID)
    REFERENCES OrderDetails (ID);

-- sequences
-- Sequence: Category_seq
CREATE SEQUENCE Category_seq
    START WITH 1 
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    NO CYCLE
    NO CACHE;

-- Sequence: Client_seq
CREATE SEQUENCE Client_seq
    START WITH 1 
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    NO CYCLE
    NO CACHE;

-- Sequence: Date_seq
CREATE SEQUENCE Date_seq
    START WITH 1 
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    NO CYCLE
    NO CACHE;

-- Sequence: Fruit_seq
CREATE SEQUENCE Fruit_seq
    START WITH 1 
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    NO CYCLE
    NO CACHE;

-- Sequence: OrderDetails_seq
CREATE SEQUENCE OrderDetails_seq
    START WITH 1 
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    NO CYCLE
    NO CACHE;

-- Sequence: Sales_seq
CREATE SEQUENCE Sales_seq
    START WITH 1 
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    NO CYCLE
    NO CACHE;

-- End of file.

