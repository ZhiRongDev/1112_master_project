USE Company;

SELECT E.Fname, E.Lname  
FROM employee AS E
WHERE E.Ssn IN (
	SELECT Essn 
    FROM dependent as D
    WHERE E.Fname = D.Dependent_name AND E.Sex = D.Sex
);

-- Can't Find Match!!!