USE Company;

SELECT Fname, Lname, 1.5*Salary
FROM EMPLOYEE, DEPARTMENT
WHERE 
	Dname = "Research" AND
    Dno = Dnumber;