SELECT Pnumber, Pname, COUNT(*)
FROM project, works_on
WHERE Pnumber = Pno
GROUP BY Pnumber, Pname;