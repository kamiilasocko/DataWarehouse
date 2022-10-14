-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-10-14 12:14:34.091

-- tables
-- Table: DimMark
CREATE TABLE DimMark (
    ID int  NOT NULL,
    Mark int  NOT NULL,
    StartDate date  NOT NULL,
    EndDate date  NOT NULL,
    CONSTRAINT DimMark_pk PRIMARY KEY  (ID)
);

-- Table: EmployeeFactTable
CREATE TABLE EmployeeFactTable (
    PESEL int  NOT NULL,
    Address varchar(50)  NOT NULL,
    Salary decimal(4,2)  NOT NULL,
    CONSTRAINT EmployeeFactTable_pk PRIMARY KEY  (PESEL)
);

-- foreign keys
-- Reference: EmployeeFactTable_DimMark (table: EmployeeFactTable)
ALTER TABLE EmployeeFactTable ADD CONSTRAINT EmployeeFactTable_DimMark
    FOREIGN KEY (PESEL)
    REFERENCES DimMark (ID);

-- End of file.

