USE Company;

SELECT DISTINCT Fname, Lname
FROM PROJECT, EMPLOYEE, WORKS_ON
WHERE 
	Dnum = 5 AND
	Pno = Pnumber AND
    Essn = Ssn;