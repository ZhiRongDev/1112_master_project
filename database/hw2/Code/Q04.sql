(
	SELECT DISTINCT Pnumber
	FROM project, department, employee
	WHERE 
		Dnum = Dnumber AND
        Mgr_ssn = Ssn AND
        Lname = "Wong"
) 
UNION
(
	SELECT DISTINCT Pnumber
    FROM project, works_on, employee
    WHERE 
		Pnumber = Pno AND
		Essn = Ssn AND
        Lname = "Wong"
);