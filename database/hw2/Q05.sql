USE Company;

SELECT E.Fname, E.Lname, S.Fname AS Supervisor_Fname, S.Lname AS Supervisor_Lname
FROM EMPLOYEE AS E, EMPLOYEE AS S
WHERE 
	E.Super_ssn = S.Ssn;