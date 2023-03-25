SELECT Fname, Lname
FROM employee
WHERE EXISTS (
	SELECT *
    FROM dependent
    WHERE Ssn = Essn
) AND EXISTS (
	SELECT *
    FROM department
    WHERE Ssn = Mgr_ssn
)