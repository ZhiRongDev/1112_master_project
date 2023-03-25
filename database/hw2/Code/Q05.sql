SELECT E.Fname, E.Lname, S.Fname, S.Lname
FROM employee AS E, employee AS S
WHERE 
	E.Super_ssn = S.Ssn;