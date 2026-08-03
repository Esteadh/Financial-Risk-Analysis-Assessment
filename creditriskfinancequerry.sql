--1.AVERAGE BALANCE
SELECT CAST(AVG(balance) as decimal (10,2)) as Avarage_Balance from Finance 

--2.AVERAGE INCOME
SELECT CAST(AVG(income) AS decimal(10,2)) as avarage_income from finance

--3. DEFAULT RATE
SELECT CAST(
 (SELECT COUNT(default_) from Finance where default_='Yes')*100.0/COUNT(default_) AS decimal (10,2)
 ) AS Default_rate from finance

--4. TOTAL CUSTOMER 
SELECT COUNT(DISTINCT Customer_id) AS numberofcustomer from Finance

--5.	AVG BALANCE FOR STUDENTS
SELECT student, CAST(AVG(balance) as decimal (10,3)) as AVGBalanceForStudent
from Finance
Group BY student

--6.	NEW COLUMN DEBT TO INCOME 
ALTER TABLE Finance
ADD DEBTTOINCOME FLOAT
     UPDATE Finance SET DEBTTOINCOME=(SELECT CAST(balance/income AS decimal(10,3)) from Finance as f2 where f2.Customer_id=Finance.Customer_id)

--7. AVG BALANCE BY INCOME GROUP AND STUDENT
SELECT student,INCOMEGROUP_LABEL,AVG(balance) AS AVG_BALANCE from Finance
GROUP BY student,INCOMEGROUP_LABEL
ORDER BY INCOMEGROUP_LABEL
C.	RISK STATUS
ALTER TABLE Finance
ADD RISKSTATUS varchar(50)
UPDATE Finance SET 
RISKSTATUS= CASE 
    WHEN DEBTTOINCOME < 0.06 THEN 'Low Risk' 
    WHEN DEBTTOINCOME < 0.16 THEN 'Normal Risk'
    WHEN DEBTTOINCOME < 0.31 THEN 'Medium Risk'
    ELSE 'High Risk' 
END

--8.	PERCENTAGE BY RISK STATUS 
SELECT RISKSTATUS, CAST(COUNT(RISKSTATUS)*100.0/(SELECT COUNT(RISKSTATUS) FROM Finance) AS decimal(10,2)) AS PERCANTAGEBYRISKSTATUS
FROM Finance 
GROUP BY RISKSTATUS
--9.	INCOME GROUP 
ALTER TABLE Finance
ADD INCOMEGROUP int
WITH QUARTER_ AS (SELECT Customer_id, NTILE(4) OVER (ORDER BY income) AS Quarternumber from Finance)
UPDATE Finance SET INCOMEGROUP=q.Quarternumber from Finance
INNER JOIN Quarter_ as q on q.customer_id=Finance.Customer_id

--10.	Income Group Label 
ALTER TABLE Finance
ADD INCOMEGROUP_LABEL varchar(50)
   UPDATE Finance SET 
INCOMEGROUP_LABEL= 
(SELECT CASE WHEN INCOMEGROUP=1 THEN 'Low income'
	     WHEN INCOMEGROUP=2 THEN 'Lower-middle income'
	     WHEN INCOMEGROUP=3 THEN 'Upper-middle income'
ELSE 'High income' end
from Finance f2
WHERE f2.Customer_id=Finance.Customer_id)
--11.	High RİSK PERCANTAGE BY STUDENT STATION EFFECT WITH INCOMEGROUP
 SELECT student,INCOMEGROUP_LABEL, 
	CAST(SUM(CASE WHEN RISKSTATUS='High Risk' THEN 1 ELSE 0 END) * 100.0/ COUNT(*) AS decimal(10,2)) AS RISK_PERCENTAGE
FROM Finance 
GROUP BY student, INCOMEGROUP_LABEL
ORDER BY student, INCOMEGROUP_LABEL

