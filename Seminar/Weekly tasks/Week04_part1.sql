/* Problem 1

For all departments, display department number and the sum of all salaries for each
department. Name the derived column SUM_SALARY.
*/

SELECT WORKDEPT, SUM(SALARY) AS "SUM_SALARY"
FROM EMPLOYEE
GROUP BY WORKDEPT;


/* Problem 2

For all departments, display the department number and the number of employees.
Name the derived column EMP_COUNT.
*/
SELECT WORKDEPT, COUNT(*) AS "EMP_COUNT"
FROM EMPLOYEE
GROUP BY WORKDEPT;


/* Problem 3

Display those departments which have more than 3 employees.
*/

SELECT WORKDEPT
FROM EMPLOYEE
GROUP BY WORKDEPT
HAVING COUNT(*) > 3;


/* Problem 4

For all departments with at least one designer, display the number of designers and
the department number. Name the derived column DESIGNER.
*/

SELECT COUNT(*) AS "DESIGNER_COUNT", WORKDEPT
FROM EMPLOYEE
WHERE JOB = 'DESIGNER'
GROUP BY WORKDEPT;


/* Problem 5

Show the average salary for men and the average salary for women for each
department. Display the work department, the sex, the average salary, average
bonus, average commission, and the number of people in each group. Include only
those groups that have two or more people. Show only two decimal places in the
averages.
Use the following names for the derived columns: AVG-SALARY, AVG-BONUS,
AVG-COMM, and COUNT.
*/

SELECT WORKDEPT, SEX, DECIMAL(AVG(SALARY), 10, 2) AS "AVG-SALARY", DECIMAL(AVG(BONUS), 10, 2) AS "AVG-BONUS", DECIMAL(AVG(COMM), 10, 2) AS "AVG-COMM", COUNT(*) AS COUNT
FROM EMPLOYEE
GROUP BY WORKDEPT, SEX
HAVING COUNT(*) >= 2;


/* Problem 6

Display the average bonus and average commission for all departments with an
average bonus greater than $500 and an average commission greater than $2,000.
Display all averages with two digits to the right of the decimal point. Use the column
headings AVG-BONUS and AVG-COMM for the derived columns.
*/

SELECT WORKDEPT, DECIMAL(AVG(BONUS), 10, 2) AS "AVG-BONUS", DECIMAL(AVG(COMM), 10, 2) AS "AVG-COMM"
FROM EMPLOYEE
GROUP BY WORKDEPT
HAVING AVG(BONUS) > 500 AND AVG(COMM) > 2000;