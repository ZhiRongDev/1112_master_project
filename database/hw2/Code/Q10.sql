SELECT Fname, Lname, 1.5*Salary
FROM employee, department
WHERE 
	Dname = "Research" AND
    Dno = Dnumber;