SELECT E.Fname, E.Lname
FROM employee AS E
WHERE E.Ssn IN (
	SELECT Essn 
    FROM dependent
    WHERE E.Fname = Dependent_name AND E.Sex = Sex
);

-- Can't Find Match!!!