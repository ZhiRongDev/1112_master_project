SELECT Fname, Lname
FROM employee
WHERE (
	SELECT COUNT(*)
    FROM dependent
    WHERE employee.Ssn = dependent.Essn
) >= 2;