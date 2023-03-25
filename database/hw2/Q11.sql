SELECT Dname, Lname, Fname, Pname
FROM department, employee, works_on, project
WHERE 
	Dnumber = Dno AND
    Ssn = Essn AND
    Pno = Pnumber
ORDER BY Dname DESC, Lname ASC, Fname ASC;