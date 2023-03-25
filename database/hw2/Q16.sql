SELECT DISTINCT Essn 
FROM works_on
WHERE Pno IN (
	SELECT Pno
    FROM works_on
    WHERE Essn = '123456789'
);