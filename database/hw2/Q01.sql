USE Company;

SELECT DISTINCT Fname, Lname, Address
FROM EMPLOYEE, DEPARTMENT
WHERE Dno = Dnumber AND Dname = "Research";