SELECT Fname, Lname
FROM employee
WHERE NOT EXISTS(
	SELECT A.Pnumber 
	FROM (
		Select PNumber
		From project
		Where Dnum = 5
	) AS A
	LEFT JOIN (
		SELECT Pno
		FROM works_on
		WHERE employee.Ssn = Essn
	) AS B
	ON A.Pnumber = B.Pno
	WHERE B.Pno IS NULL
);