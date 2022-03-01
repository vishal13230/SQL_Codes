-- CTE : COMMON TABLE EXPRESSIONS (QUERIES USING WITH CLAUSE)
-- EXAMPLE 1
DROP TABLE IF EXISTS EMPLOYEE_DATA;
GO
CREATE TABLE EMPLOYEE_DATA (EMP_ID INT, 
							EMP_NAME VARCHAR(50), 
							SALARY INT);

INSERT INTO EMPLOYEE_DATA VALUES(101, 'MOHAN', 40000);
INSERT INTO EMPLOYEE_DATA VALUES(102, 'JAMES', 50000);
INSERT INTO EMPLOYEE_DATA VALUES(103, 'ROBIN', 60000);
INSERT INTO EMPLOYEE_DATA VALUES(104, 'CAROL', 70000);
INSERT INTO EMPLOYEE_DATA VALUES(105, 'ALICE', 80000);
INSERT INTO EMPLOYEE_DATA VALUES(106, 'JIMMY', 90000);

SELECT *
FROM EMPLOYEE_DATA;

-- FETCH ALL EMPLOYEES WHO EARNS MORE THAN AVERAGE SALARY OF ALL EMPLOYEES
WITH TEMP_AVG_SALARY (AVG_SALARY) AS 
	(SELECT CAST(AVG(SALARY) AS INT) FROM EMPLOYEE_DATA)

SELECT *
FROM EMPLOYEE_DATA, TEMP_AVG_SALARY
WHERE SALARY > AVG_SALARY;

-- EXAMPLE 2
DROP TABLE IF EXISTS SALES;
GO
CREATE TABLE SALES
	(STORE_ID  INT, STORE_NAME VARCHAR(50), PRODUCT VARCHAR(50), QUANTITY INT, COST INT);

INSERT INTO SALES VALUES
(1, 'APPLE ORIGINALS 1','IPHONE 12 PRO', 1, 1000),
(1, 'APPLE ORIGINALS 1','MACBOOK PRO 13', 3, 2000),
(1, 'APPLE ORIGINALS 1','AIRPODS PRO', 2, 280),
(2, 'APPLE ORIGINALS 2','IPHONE 12 PRO', 2, 1000),
(3, 'APPLE ORIGINALS 3','IPHONE 12 PRO', 1, 1000),
(3, 'APPLE ORIGINALS 3','MACBOOK PRO 13', 1, 2000),
(3, 'APPLE ORIGINALS 3','MACBOOK AIR', 4, 1100),
(3, 'APPLE ORIGINALS 3','IPHONE 12', 2, 1000),
(3, 'APPLE ORIGINALS 3','AIRPODS PRO', 3, 280),
(4, 'APPLE ORIGINALS 4','IPHONE 12 PRO', 2, 1000),
(4, 'APPLE ORIGINALS 4','MACBOOK PRO 13', 1, 2500);

SELECT *
FROM SALES;

-- FIND THE STORES WHOSE SALE IS BETTER THAN AVERAGE SALES OF ALL THE STORES
WITH TEMP_AVG_SALES(AVG_SALES) AS
	(SELECT AVG((QUANTITY * COST)) FROM SALES)
SELECT *
FROM SALES, TEMP_AVG_SALES
WHERE QUANTITY * COST > AVG_SALES

-- TOTAL SALES BY EACH STORE
SELECT STORE_ID, SUM(COST) AS TOTAL_SALES_BY_STORE
FROM SALES
GROUP BY STORE_ID;

-- AVERAGE SALES BY STORE
SELECT AVG(TOTAL_SALES_BY_STORE) AS AVG_SALES_BY_STORE
FROM 
	(SELECT STORE_ID, SUM(COST) AS TOTAL_SALES_BY_STORE
	 FROM SALES
	 GROUP BY STORE_ID) AS A;

-- FIND THE STORES WHERE TOTAL SALES > AVG SALES OF ALL THE STORES - USING SUBQUERY
SELECT *
FROM 
	(SELECT STORE_ID, SUM(COST) AS TOTAL_SALES_BY_STORE
	 FROM SALES
	 GROUP BY STORE_ID) T
JOIN 
	(SELECT AVG(TOTAL_SALES_BY_STORE) AS AVG_SALES_BY_STORE
	 FROM 
		 (SELECT STORE_ID, SUM(COST) AS TOTAL_SALES_BY_STORE
		  FROM SALES
		  GROUP BY STORE_ID) AS A) AS ATS
ON T.TOTAL_SALES_BY_STORE > ATS.AVG_SALES_BY_STORE;

-- FIND THE STORES WHERE TOTAL SALES > AVG SALES OF ALL THE STORES - USING WITH CLAUSE
WITH TEMP_TOTAL_SALES(STORE_ID, TOTAL_SALES_BY_STORE) AS 
	(SELECT STORE_ID, SUM(COST) AS TOTAL_SALES_BY_STORE
	 FROM SALES
	 GROUP BY STORE_ID), 

	 TEMP_AVG_SALES(AVG_SALES_BY_STORE) AS
	 (SELECT AVG(TOTAL_SALES_BY_STORE) AS AVG_SALES_BY_STORE
	  FROM TEMP_TOTAL_SALES)
SELECT *
FROM TEMP_TOTAL_SALES AS T
JOIN TEMP_AVG_SALES AS A
ON T.TOTAL_SALES_BY_STORE > A.AVG_SALES_BY_STORE;