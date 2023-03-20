USE Company;

SELECT DISTINCT Pnumber, Dnum, Lname, Address, Bdate
FROM PROJECT, DEPARTMENT, EMPLOYEE
WHERE 
	Plocation = "Stafford" AND 
    Dnum = Dnumber AND
    Mgr_ssn = Ssn;