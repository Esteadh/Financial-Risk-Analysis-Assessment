# Financial-Risk-Analysis-Assessment
This study examines risk among students and non-students based on their income and account balances. Excel, Power BI, and MSSQL were used together in this study.
![MSSQL](https://img.shields.io/badge/Database-MS_SQL_Server-red.svg) ![Excel](https://img.shields.io/badge/Microsoft_Excel-217346?style=flat&logo=microsoft-excel&logoColor=white)  ![Power BI](https://img.shields.io/badge/Power_BI-F2C94C?style=flat&logo=power-bi&logoColor=black) 
# Project Summary
In this study, a dataset of 10,000 rows obtained from Kaggle underwent the necessary data cleaning processes, was converted into the required SQL queries using MSSQL, and was then visualized using DAX formulas in Power BI.
# Sample Query And Output
# 1. AVERAGE Balance
SELECT CAST(AVG(balance) as decimal (10,2)) as Avarage_Balance from Finance 


<img width="190" height="65" alt="image" src="https://github.com/user-attachments/assets/8caabc01-ed3d-4cff-baeb-21f4f2b5e18b" />



# 2. AVERAGE INCOME 
SELECT CAST(AVG(income) AS decimal(10,2)) as avarage_income from finance


<img width="184" height="58" alt="image" src="https://github.com/user-attachments/assets/353c40c3-9fb0-4e60-abfc-d6d480d900c6" />



# 3. DEFAULT RATE
SELECT CAST(
 (SELECT COUNT(default_) from Finance where default_='Yes')*100.0/COUNT(default_) AS decimal (10,2)
 ) AS Default_rate from finance



<img width="150" height="46" alt="image" src="https://github.com/user-attachments/assets/5c9e0d45-b1a5-483a-93b4-8b316ce07ac8" />



# 4. TOTAL CUSTOMER 
SELECT COUNT(DISTINCT Customer_id) AS numberofcustomer from Finance



<img width="191" height="51" alt="image" src="https://github.com/user-attachments/assets/a9749665-7aa3-4274-8d54-2c516a9ebbd8" />



# 5. AVG BALANCE FOR STUDENTS
SELECT student, CAST(AVG(balance) as decimal (10,3)) as AVGBalanceForStudent
from Finance
Group BY student




<img width="303" height="83" alt="image" src="https://github.com/user-attachments/assets/6e8e027f-b0b5-47f3-bac2-fd09a82f39c2" />



# 6. NEW COLUMN DEBT TO INCOME
ALTER TABLE Finance
ADD DEBTTOINCOME FLOAT
     UPDATE Finance SET DEBTTOINCOME=(SELECT CAST(balance/income AS decimal(10,3)) from Finance as f2 where f2.Customer_id=Finance.Customer_id)


<img width="746" height="225" alt="image" src="https://github.com/user-attachments/assets/29ba0b64-0206-415b-94df-a08610ffd17a" />




# 7. AVG BALANCE BY INCOME GROUP AND STUDENT
SELECT student,INCOMEGROUP_LABEL,AVG(balance) AS AVG_BALANCE from Finance
GROUP BY student,INCOMEGROUP_LABEL
ORDER BY INCOMEGROUP_LABEL




<img width="459" height="178" alt="image" src="https://github.com/user-attachments/assets/8b410d00-d529-4423-9a33-c2e506f92910" />




# 8. RISK STATUS
ALTER TABLE Finance
ADD RISKSTATUS varchar(50)
UPDATE Finance SET 
RISKSTATUS= CASE 
    WHEN DEBTTOINCOME < 0.06 THEN 'Low Risk' 
    WHEN DEBTTOINCOME < 0.16 THEN 'Normal Risk'
    WHEN DEBTTOINCOME < 0.31 THEN 'Medium Risk'
    ELSE 'High Risk' 
END

D.	PERCENTAGE BY RISK STATUS 
SELECT RISKSTATUS, CAST(COUNT(RISKSTATUS)*100.0/(SELECT COUNT(RISKSTATUS) FROM Finance) AS decimal(10,2)) AS PERCANTAGEBYRISKSTATUS
FROM Finance 
GROUP BY RISKSTATUS




<img width="390" height="125" alt="image" src="https://github.com/user-attachments/assets/d328479e-8a7f-43e4-94cc-99848f52c622" />





# 9. INCOME GROUP 
ALTER TABLE Finance
ADD INCOMEGROUP int
WITH QUARTER_ AS (SELECT Customer_id, NTILE(4) OVER (ORDER BY income) AS Quarternumber from Finance)
UPDATE Finance SET INCOMEGROUP=q.Quarternumber from Finance
INNER JOIN Quarter_ as q on q.customer_id=Finance.Customer_id




<img width="683" height="174" alt="image" src="https://github.com/user-attachments/assets/069586fa-19c7-46de-8130-b1f95e64dc30" />







# 10. Income Group Label 
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





<img width="765" height="195" alt="image" src="https://github.com/user-attachments/assets/25630f3d-c552-4e0a-afc4-eb694a645684" />





# 11. High RİSK PERCANTAGE BY STUDENT STATION EFFECT WITH INCOMEGROUP
 SELECT student,INCOMEGROUP_LABEL, 
	CAST(SUM(CASE WHEN RISKSTATUS='High Risk' THEN 1 ELSE 0 END) * 100.0/ COUNT(*) AS decimal(10,2)) AS RISK_PERCENTAGE
FROM Finance 
GROUP BY student, INCOMEGROUP_LABEL
ORDER BY student, INCOMEGROUP_LABEL







<img width="483" height="175" alt="image" src="https://github.com/user-attachments/assets/19b441ad-7087-469f-84ef-5a2a433ab776" />






