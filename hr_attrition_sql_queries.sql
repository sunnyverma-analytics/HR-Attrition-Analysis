CREATE TABLE attrition (age INT,attrition VARCHAR(10),
    businesstravel VARCHAR(50),dailyrate INT,department VARCHAR(100),
    distancefromhome INT, education INT,
    educationfield VARCHAR(100),employeecount INT,
    employeenumber INT,environmentsatisfaction INT,
    gender VARCHAR(20),hourlyrate INT,
    jobinvolvement INT,joblevel INT,
    jobrole VARCHAR(100),
    jobsatisfaction INT,maritalstatus VARCHAR(50),
    monthlyincome INT,monthlyrate INT,
    numcompaniesworked INT,over18 VARCHAR(5),
    overtime VARCHAR(10),percentsalaryhike INT,
    performancerating INT,relationshipsatisfaction INT,
    standardhours INT,stockoptionlevel INT,
    totalworkingyears INT,trainingtimeslastyear INT,
    worklifebalance INT, yearsatcompany INT,
    yearsincurrentrole INT,yearssincelastpromotion INT,
    yearswithcurrmanager INT,income_group VARCHAR(50),
    experience_group VARCHAR(50),age_group VARCHAR(50)
);

SELECT * FROM attrition;
/*----------------------------------------------------
 SECTION 1: Executive HR KPIs
-----------------------------------------------------*/


--1.How many employees are currently working in the organization?--
SELECT COUNT(*) AS total_employees
FROM attrition;

--2.How many employees have left the organization?--
SELECT COUNT(*) AS attrition_count
FROM attrition
WHERE attrition = 'Yes';

--3.What is the overall employee attrition rate?--
SELECT
ROUND(
100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)
/ COUNT(*),2
) AS attrition_rate
FROM attrition;

--4.What is the average age of employees across the organization?--
SELECT ROUND(AVG(age),2) AS avg_age
FROM attrition;

--5.What is the average monthly income of employees?--
SELECT ROUND(AVG(monthlyincome),2)
FROM attrition;

--6.What is the average employee tenure in the company?--
SELECT ROUND(AVG(yearsatcompany),2)
FROM attrition;


/*----------------------------------------------------
 SECTION 2: Workforce Segmentation Analysis
-----------------------------------------------------*/

--1.Does employee attrition vary across genders?--
SELECT
gender,
COUNT(*) AS employees,
SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) AS attrition
FROM attrition
GROUP BY gender;

--2.Which job roles are most affected by employee attrition?--
SELECT
jobrole,
COUNT(*) AS employees,
SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) AS attrition
FROM attrition
GROUP BY jobrole
ORDER BY attrition DESC;

--3.How does attrition differ across marital status groups?--
SELECT
maritalstatus,
COUNT(*) AS employees,
SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) AS attrition
FROM attrition
GROUP BY maritalstatus;

--4.Which education backgrounds show the highest attrition levels?--
SELECT
educationfield,
COUNT(*) AS employees,
SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) AS attrition
FROM attrition
GROUP BY educationfield
ORDER BY attrition DESC;

--5.Does overtime contribute to higher employee attrition?--
SELECT
overtime,
COUNT(*) AS employees,
SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) AS attrition
FROM attrition
GROUP BY overtime;

--6.Which age groups are most vulnerable to attrition?--
SELECT
age_group,
COUNT(*) AS employees,
SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) AS attrition
FROM attrition
GROUP BY age_group;

/*----------------------------------------------------
 SECTION 3: Compensation Analysis
-----------------------------------------------------*/

--1.Which departments offer the highest average salaries?--
SELECT
department,
ROUND(AVG(monthlyincome),2) avg_salary
FROM attrition
GROUP BY department
ORDER BY avg_salary DESC;

/*----------------------------------------------------
 SECTION 4: Advanced SQL Analytics
-----------------------------------------------------*/

--1.How do employee salaries rank across the organization?-
SELECT
employeenumber,
department,
monthlyincome,
RANK() OVER(
ORDER BY monthlyincome DESC
) salary_rank
FROM attrition;

--2.Who is the highest-paid employee within each department?--
SELECT * FROM (SELECT
department,employeenumber,
monthlyincome,
RANK() OVER(
PARTITION BY department
ORDER BY monthlyincome DESC) rnk
FROM attrition) x
WHERE rnk = 1;

--3.How do salary rankings compare within each department?--
SELECT
department,
monthlyincome,
DENSE_RANK() OVER(
PARTITION BY department
ORDER BY monthlyincome DESC
) rank_no
FROM attrition;

--4.How can employees be segmented into salary quartiles?--
SELECT
employeenumber,
monthlyincome,
NTILE(4) OVER(
ORDER BY monthlyincome
) quartile
FROM attrition;



/*----------------------------------------------------
 SECTION 5: Attrition Driver Analysis
-----------------------------------------------------*/

--1.Which departments have the highest attrition rates relative to workforce size?--
SELECT department,ROUND(100.0 *
SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)/
COUNT(*),2) attrition_rate
FROM attrition
GROUP BY department;

--2.Does work-life balance impact employee retention?--
SELECT
worklifebalance,
COUNT(*) employees,
SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) attrition
FROM attrition
GROUP BY worklifebalance;

--3.Which income group experiences the highest attrition rate?--
SELECT income_group, ROUND(
100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) /
COUNT(*),2) AS attrition_rate
FROM attrition
GROUP BY income_group
ORDER BY attrition_rate DESC;

--4.Which experience group experiences the highest attrition rate?--
SELECT experience_group,
ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) /
COUNT(*),2
) AS attrition_rate
FROM attrition
GROUP BY experience_group
ORDER BY attrition_rate DESC;

--5.How does overtime affect employee attrition rates?--
SELECT overtime,
ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)
/
COUNT(*),2
) AS attrition_rate
FROM attrition
GROUP BY overtime;

--6.How does job satisfaction affect attrition rates?--
SELECT jobsatisfaction,
ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)
/
COUNT(*),2
) AS attrition_rate
FROM attrition
GROUP BY jobsatisfaction
ORDER BY jobsatisfaction;

/*----------------------------------------------------
 SECTION 6: Department Performance Analysis
-----------------------------------------------------*/

--1.Which departments differ most in workforce size, salary, age profile, and attrition?--
SELECT department,
COUNT(*) total_emp,
ROUND(AVG(age),2) avg_age,
ROUND(AVG(monthlyincome),2) avg_salary,
SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) attrition
FROM attrition
GROUP BY department;

/*----------------------------------------------------
 SECTION 7: Business-Focused Analysis
-----------------------------------------------------*/

--1.Which employee segment is at the highest risk of attrition?--
SELECT age_group, income_group,
experience_group,
COUNT(*) AS employees,
SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) AS attrition_count
FROM attrition
GROUP BY age_group, income_group, experience_group
ORDER BY attrition_count DESC;

--2.Which job roles have the highest attrition rates?--
SELECT jobrole,
ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)
/
COUNT(*),2
) AS attrition_rate
FROM attrition
GROUP BY jobrole
ORDER BY attrition_rate DESC;

--3.Which combination of factors creates the highest attrition risk?--
SELECT department, overtime, income_group,
COUNT(*) employees,
SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) attrition_count
FROM attrition
GROUP BY department, overtime, income_group
ORDER BY attrition_count DESC;

--4.Does business travel influence employee attrition?--
SELECT
businesstravel,
ROUND(
100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)
/ COUNT(*),2
) AS attrition_rate
FROM attrition
GROUP BY businesstravel
ORDER BY attrition_rate DESC;

--5.Does distance from home impact attrition?--
SELECT
CASE
WHEN distancefromhome <= 5 THEN 'Near'
WHEN distancefromhome <= 15 THEN 'Medium'
ELSE 'Far'
END AS distance_group,
ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)
/ COUNT(*),2) AS attrition_rate
FROM attrition

GROUP BY distance_group
ORDER BY attrition_rate DESC;

--6.Does stock option level affect employee retention?--
SELECT stockoptionlevel,
ROUND(
100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)
/ COUNT(*),2) AS attrition_rate
FROM attrition
GROUP BY stockoptionlevel
ORDER BY stockoptionlevel;





