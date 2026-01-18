select * from hr_data;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Average Attrition Rate for all department.--
create table KPI1
select 
    Department,
    concat(ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2),'%') AS Avg_Attrition_Rate
FROM hr_data
GROUP BY Department order by Avg_Attrition_Rate desc;
select * from KPI1;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Average Hourly rate of male research scientists.--
create table KPI2
SELECT
    JobRole,
    Gender,
    ROUND(AVG(HourlyRate), 2) AS Avg_HourlyRate
FROM hr_data
WHERE Gender='Male' AND JobRole='Research Scientist'
GROUP BY JobRole, Gender;
select * from KPI2;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Attrition rate vs monthly income stats.--
create table KPI3
SELECT
    CASE 
        WHEN MonthlyIncome BETWEEN 0 AND 4999 THEN '0 - 4999'
        WHEN MonthlyIncome BETWEEN 5000 AND 9999 THEN '5000 - 9999'
        WHEN MonthlyIncome BETWEEN 10000 AND 14999 THEN '10000 - 14999'
        WHEN MonthlyIncome BETWEEN 15000 AND 19999 THEN '15000 - 19999'
        WHEN MonthlyIncome BETWEEN 20000 AND 24999 THEN '20000 - 24999'
        WHEN MonthlyIncome BETWEEN 25000 AND 29999 THEN '25000 - 29999'
        WHEN MonthlyIncome BETWEEN 30000 AND 34999 THEN '30000 - 34999'
        WHEN MonthlyIncome BETWEEN 35000 AND 39999 THEN '35000 - 39999'
        WHEN MonthlyIncome BETWEEN 40000 AND 44999 THEN '40000 - 44999'
        WHEN MonthlyIncome BETWEEN 45000 AND 49999 THEN '45000 - 49999'
        ELSE '50000+'
    END AS Income_Range,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    concat(ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100,2),'%') AS Attrition_Rate_Percent
FROM hr_data
GROUP BY Income_Range
ORDER BY Income_Range;
select * from KPI3;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Average working years for each department.--
create table KPI4
select
	Department, 
    round(avg(totalworkingyears),2) as avg_workingyears
from hr_data
group by department;
select * from KPI4;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Job role vs work-life balance.--
create table KPI5
select
	jobrole,
    round(avg(worklifebalance),2) as avg_worklifebalance
from hr_data
group by JobRole
order by avg_worklifebalance;
select * from KPI5;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Attrition rate vs years since last promotion.--
create table KPI6
select
	CASE 
        WHEN YearsSinceLastPromotion between 0 and 5 then '0-5 years'
        WHEN YearsSinceLastPromotion between 6 and 10 then '6-10 years'
        WHEN YearsSinceLastPromotion between 11 and 20 then '11-20 years'
        WHEN YearsSinceLastPromotion between 21 and 30 then '21-30 years'
        WHEN YearsSinceLastPromotion between 31 and 40 then '31-40 years'
        ELSE '40+ years'
    END AS YearsSinceLastPromotion_Group,
    count(*) AS total_employees,
    sum(case when attrition='Yes' then 1 else 0 end) as total_attrition,
    concat(round(sum(case when attrition='Yes' then 1 else 0 end)/count(*)*100,2),'%') as attrition_rate
from hr_data
group by YearsSinceLastPromotion_Group
order by total_employees desc;
select * from KPI6;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Attrition Rate vs Age Group.--
create table KPI7
SELECT 
    CASE 
        WHEN Age < 25 THEN 'Below 25'
        WHEN Age BETWEEN 25 AND 35 THEN '25-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56 and above'
    END AS Age_Group,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    concat(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100,2),'%') AS Attrition_Rate_Percentage
FROM hr_data
GROUP BY Age_Group
ORDER BY Attrition_Rate_Percentage DESC;
select * from KPI7;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Top 3 highest earning employees per department.--
create table KPI8
	with incomeCTE as (select `EmployeeNumber`, Department, MonthlyIncome,
    row_number() over (partition by department order by monthlyincome desc) as IncomeRank
    from hr_data)
select * from IncomeCTE
where IncomeRank <= 3;
select * from KPI8;