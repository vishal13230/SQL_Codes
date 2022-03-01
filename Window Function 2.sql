-- Script to create the Product table and load data into it.
Drop Table If Exists Product;
Go
Create Table Product
	(Product_Category Varchar(255),
     Brand Varchar(255),
     Product_Name Varchar(255),
     Price Int);

Insert Into Product Values
	('Phone', 'Apple', 'iPhone 12 Pro Max', 1300),
	('Phone', 'Apple', 'iPhone 12 Pro', 1100),
	('Phone', 'Apple', 'iPhone 12', 1000),
	('Phone', 'Samsung', 'Galaxy Z Fold 3', 1800),
	('Phone', 'Samsung', 'Galaxy Z Flip 3', 1000),
	('Phone', 'Samsung', 'Galaxy Note 20', 1200),
	('Phone', 'Samsung', 'Galaxy S21', 1000),
	('Phone', 'OnePlus', 'OnePlus Nord', 300),
	('Phone', 'OnePlus', 'OnePlus 9', 800),
	('Phone', 'Google', 'Pixel 5', 600),
	('Laptop', 'Apple', 'MacBook Pro 13', 2000),
	('Laptop', 'Apple', 'MacBook Air', 1200),
	('Laptop', 'Microsoft', 'Surface Laptop 4', 2100),
	('Laptop', 'Dell', 'XPS 13', 2000),
	('Laptop', 'Dell', 'XPS 15', 2300),
	('Laptop', 'Dell', 'XPS 17', 2500),
	('Earphone', 'Apple', 'AirPods Pro', 280),
	('Earphone', 'Samsung', 'Galaxy Buds Pro', 220),
	('Earphone', 'Samsung', 'Galaxy Buds Live', 170),
	('Earphone', 'Sony', 'WF-1000XM4', 250),
	('Headphone', 'Sony', 'WH-1000XM4', 400),
	('Headphone', 'Apple', 'AirPods Max', 550),
	('Headphone', 'Microsoft', 'Surface Headphones 2', 250),
	('Smartwatch', 'Apple', 'Apple Watch Series 6', 1000),
	('Smartwatch', 'Apple', 'Apple Watch SE', 400),
	('Smartwatch', 'Samsung', 'Galaxy Watch 4', 600),
	('Smartwatch', 'OnePlus', 'OnePlus Watch', 220);

Select *
From Product;

-- First Value
-- Write a query to display the most expensive product under each category (corresponding to each records).
Select *,
		First_Value(Product_Name) Over(Partition By Product_Category Order By Price Desc) Most_Expensive_Product
From Product;

-- Last Value - Frame Clause
-- Applying Framework Clause
-- Write a query to display the least expensive product under each category (corresponding to each records).
Select *,
		Last_Value(Product_Name) Over(Partition By Product_Category Order By Price Desc -- Applying Framework Clause
		Range Between Unbounded Preceding And Unbounded Following) -- Unbounded Following Insted of Current Row Which is Default
		Least_Expensive_Product
From Product;

-- Combining First Value and Last Value Window Function
Select *,
		First_Value(Product_Name) Over(Partition By Product_Category Order By Price Desc) Most_Expensive_Product,
		Last_Value(Product_Name) Over(Partition By Product_Category Order By Price Desc 
		Range Between Unbounded Preceding And Unbounded Following) Least_Expensive_Product
From Product;
