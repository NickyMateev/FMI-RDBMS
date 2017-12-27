/* Problem 1

Produce a report that lists employees' last names, first names, and department
names. Sequence the report on first name within last name, within department
name.
*/

SELECT E.LASTNAME, E.FIRSTNME, D.DEPTNAME
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.WORKDEPT = D.DEPTNO
ORDER BY D.DEPTNAME, E.LASTNAME, E.FIRSTNME;


/* Problem 2

Modify the previous query to include job. Also, list data for only departments
between A02 and D22, and exclude managers from the list. Sequence the report on
first name within last name, within job, within department name.
*/

SELECT E.LASTNAME, E.FIRSTNME, D.DEPTNAME, E.JOB
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.WORKDEPT = D.DEPTNO
	AND D.DEPTNO BETWEEN 'A02' AND 'D22'
	AND E.JOB <> 'MANAGER'
ORDER BY D.DEPTNAME, E.JOB, E.LASTNAME, E.FIRSTNME;


/* Problem 3

List the name of each department and the lastname and first name of its manager.
Sequence the list by department name. Use the EMPNO and MGRNO columns to
relate the two tables. Sequence the result rows by department name.
*/

SELECT D.DEPTNAME, E.LASTNAME, E.FIRSTNME
FROM DEPARTMENT D, EMPLOYEE E
WHERE D.MGRNO = E.EMPNO
ORDER BY D.DEPTNAME;


/* Problem 4

Try the following: modify the previous query using WORKDEPT and DEPTNO as the
join predicate. Include a local predicate that looks for people whose job is manager.

Are the results from both queries the same? -> No, they're not.

Why? -> The results are not the same, because the president of the company
doesn't have the 'MANAGER' value as part of his Job property, but rather he has 'PRES'.
This causes the two queries to differ by 1 result.
*/

SELECT D.DEPTNAME, E.LASTNAME, E.FIRSTNME
FROM DEPARTMENT D, EMPLOYEE E
WHERE D.DEPTNO = E.WORKDEPT
	AND E.JOB = 'MANAGER'
ORDER BY D.DEPTNAME;


/* Problem 5

For all projects that have a project number beginning with AD, list project number,
project name, and activity number. List identical rows once. Order the list by project
number and then by activity number.
*/

SELECT DISTINCT P.PROJNO, P.PROJNAME, A.ACTNO
FROM PROJECT P, EMP_ACT A
WHERE P.PROJNO = A.PROJNO
	AND P.PROJNO LIKE 'AD%'
ORDER BY P.PROJNO, A.ACTNO;


/* Problem 6

Which employees are assigned to project number AD3113? List employee number,
last name, and project number. Order the list by employee number and then by
project number. List only one occurrence of duplicate result rows.
*/

SELECT DISTINCT E.EMPNO, E.LASTNAME, A.PROJNO
FROM EMPLOYEE E, EMP_ACT A
WHERE E.EMPNO = A.EMPNO
	AND A.PROJNO = 'AD3113'
ORDER BY E.EMPNO, A.PROJNO;


/* Problem 7

Which activities began on October 1, 1982? For each of these activities, list the
employee number of the person performing the activity, the project number, project
name, activity number, and starting date of the activity. Order the list by project
number, then by employee number, and then by activity number.
*/

SELECT A.EMPNO, A.PROJNO, P.PROJNAME, A.ACTNO, A.EMSTDATE
FROM EMP_ACT A, PROJECT P
WHERE A.PROJNO = P.PROJNO
	AND A.EMSTDATE = '1982-10-01'
ORDER BY A.PROJNO, A.EMPNO, A.ACTNO;


/* Problem 8

Display department number, last name, project name, and activity number for
activities performed by the employees in department A00.
Sequence the results first by project name and then by activity number.
*/

SELECT E.WORKDEPT, E.LASTNAME, P.PROJNAME, A.ACTNO
FROM EMPLOYEE E, EMP_ACT A, PROJECT P
WHERE E.EMPNO = A.EMPNO
	AND A.PROJNO = P.PROJNO
	AND E.WORKDEPT = 'A00'
ORDER BY P.PROJNAME, A.ACTNO;


/* Problem 9

List department number, last name, project name, and activity number for those
employees in work departments A00 through C01. Suppress identical rows.
Sort the list by department number, last name, and activity number.
*/

SELECT DISTINCT E.WORKDEPT, E.LASTNAME, P.PROJNAME, A.ACTNO
FROM EMPLOYEE E, EMP_ACT A, PROJECT P
WHERE E.EMPNO = A.EMPNO
	AND A.PROJNO = P.PROJNO
	AND E.WORKDEPT BETWEEN 'A00' AND 'C01'
ORDER BY E.WORKDEPT, E.LASTNAME, A.ACTNO;


/* Problem 10

The second line manager needs a list of activities which began on October 15, 1982
or thereafter.
For these activities, list the activity number, the manager number of the manager of
the department assigned to the project, the starting date for the activity, the project
number, and the last name of the employee performing the activity.
The list should be ordered by the activity number and then by the activity start date.
*/

SELECT A.ACTNO, D.MGRNO, A.EMSTDATE, A.PROJNO, P.PROJNO, E.LASTNAME
FROM EMPLOYEE AS E
	JOIN EMP_ACT AS A
    	ON E.EMPNO = A.EMPNO
	JOIN PROJECT AS P
		ON A.PROJNO = P.PROJNO
	JOIN DEPARTMENT AS D
		ON E.WORKDEPT = D.DEPTNO 
	AND A.EMSTDATE >= '1982-10-15'
ORDER BY A.ACTNO, A.EMSTDATE;


/* Problem 11

Which employees in department A00 were hired before their manager?
List department number, the manager's last name, the employee's last name, and
the hiring dates of both the manager and the employee.
Order the list by the employee's last name.
*/

SELECT E.WORKDEPT, M.LASTNAME AS MANAGER_LASTNAME, E.LASTNAME EMPLOYEE_LASTNAME, M.HIREDATE AS MGR_START_DATE, E.HIREDATE AS EMP_START_DATE
FROM EMPLOYEE E, DEPARTMENT D, EMPLOYEE M
WHERE E.WORKDEPT = D.DEPTNO
	AND D.MGRNO = M.EMPNO
	AND D.DEPTNO = 'A00'
	AND E.HIREDATE < M.HIREDATE
ORDER BY E.LASTNAME;