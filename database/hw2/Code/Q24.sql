SELECT Pnumber, Pname, COUNT(*)
FROM project, works_on, employee
WHERE Pnumber = Pno AND Essn = Ssn AND Dno = 5
GROUP BY Pnumber, Pname;