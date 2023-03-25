SELECT DISTINCT Pnumber, Dnum, Lname, Address, Bdate
FROM project, department, employee
WHERE 
	Plocation = "Stafford" AND 
    Dnum = Dnumber AND
    Mgr_ssn = Ssn;