SELECT DISTINCT Fname, Lname, Address
FROM employee, department
WHERE Dno = Dnumber AND Dname = "Research";