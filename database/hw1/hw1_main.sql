CREATE SCHEMA Company;
USE Company;

CREATE TABLE DEPARTMENT (
	Dname VARCHAR(20) NOT NULL,
	Dnumber INT NOT NULL,
    -- Mgr_ssn should can be NULL (foreign key), but the textbook set NOT NULL (it set ON DELETE DEFAULT, page 185)
    -- Looks like InnoDB cannot use ON DELETE SET DEFAULT or ON UPDATE SET DEFAULT
    Mgr_ssn CHAR(9),
    Mgr_start_date DATE,
    PRIMARY KEY(Dnumber)
);

CREATE TABLE EMPLOYEE (
	Fname VARCHAR(20) NOT NULL,
	Minit CHAR,
    Lname VARCHAR(20) NOT NULL,
    Ssn CHAR(9) NOT NULL,
    Bdate DATE,
    Address VARCHAR(50),
    Sex CHAR,
    Salary DECIMAL(10, 2),
    Super_ssn CHAR(9),
	-- Dno should can be NULL (FK), but the textbook set NOT NULL (it set ON DELETE DEFAULT, page 185)
    Dno INT,
    PRIMARY KEY(Ssn)
);

CREATE TABLE PROJECT (
	Pname VARCHAR(20) NOT NULL,
    Pnumber INT NOT NULL,
    Plocation VARCHAR(20),
    -- Dnum should can be NULL (FK), but the textbook set NOT NULL (it set ON DELETE DEFAULT, page 185)
    Dnum INT,
    PRIMARY KEY(Pnumber)
);

CREATE TABLE DEPENDENT(
	Essn CHAR(9) NOT NULL,
    Dependent_name VARCHAR(20) NOT NULL, 
    Sex CHAR,
    Bdate DATE,
    Reletionship VARCHAR(20),
    PRIMARY KEY(Essn, Dependent_name)
);

CREATE TABLE DEPT_LOCATIONS(
	Dnumber INT NOT NULL,
    Dlocation VARCHAR(20) NOT NULL,
    PRIMARY KEY(Dnumber, Dlocation)
);

CREATE TABLE WORKS_ON(
	Essn CHAR(9) NOT NULL,
    Pno INT NOT NULL,
    Hours FLOAT(2),
    PRIMARY KEY(Essn, Pno)
);

INSERT INTO EMPLOYEE(Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
	VALUES 
		('James','E','Borg',888665555,'1937-11-10','450 Stone, Houston TX','M',55000,null,1),
		('Franklin','T','Wong',333445555,'1965-12-08','638 Voss, Houston TX','M',40000,888665555,5),
		('Jennifer','S','Wallace',987654321,'1941-06-20','291 Berry, Bellaire TX','F',43000,888665555,4);

INSERT INTO DEPARTMENT(Dname, Dnumber, Mgr_ssn, Mgr_start_date)
	VALUES
		('Research',5,333445555,'1988-05-22'),
		('Administration',4,987654321,'1995-01-01'),
		('Headquarters',1,888665555,'1981-06-19');

ALTER TABLE DEPARTMENT
	ADD CONSTRAINT DEPARTMENT_Mgr_ssn_fk
		FOREIGN KEY(Mgr_ssn) REFERENCES EMPLOYEE(Ssn)
			ON DELETE SET NULL
            ON UPDATE CASCADE,
	ADD CONSTRAINT DEPARTMENT_unique
		UNIQUE (Dname);

ALTER TABLE EMPLOYEE
	ADD CONSTRAINT EMPLOYEE_Super_Ssn_fk 
		FOREIGN KEY(Super_Ssn) REFERENCES EMPLOYEE(Ssn)
			ON DELETE SET NULL
            ON UPDATE CASCADE,
	ADD CONSTRAINT EMPLOYEE_Dno_fk
		FOREIGN KEY(Dno) REFERENCES DEPARTMENT(Dnumber)
			ON DELETE SET NULL
            ON UPDATE CASCADE;

ALTER TABLE PROJECT
	ADD CONSTRAINT PROJECT_Dnum_fk
		FOREIGN KEY(Dnum) REFERENCES DEPARTMENT(Dnumber)
			ON DELETE SET NULL
            ON UPDATE CASCADE,
	ADD CONSTRAINT PROJECT_unique
		UNIQUE(Pname);

ALTER TABLE DEPENDENT
	ADD CONSTRAINT DEPENDENT_Essn_fk
		FOREIGN KEY(Essn) REFERENCES EMPLOYEE(Ssn)
			ON DELETE CASCADE
            ON UPDATE CASCADE;

ALTER TABLE DEPT_LOCATIONS
	ADD CONSTRAINT DEPT_LOCATIONS_Dnumber_fk
		FOREIGN KEY(Dnumber) REFERENCES DEPARTMENT(Dnumber)
			ON DELETE CASCADE
            ON UPDATE CASCADE;

ALTER TABLE WORKS_ON
	ADD CONSTRAINT WORKS_ON_Essn_fk
		FOREIGN KEY(Essn) REFERENCES EMPLOYEE(Ssn)
			ON DELETE CASCADE
            ON UPDATE CASCADE,
	ADD CONSTRAINT WORKS_ON_Pno_fk
		FOREIGN KEY(Pno) REFERENCES PROJECT(Pnumber)
			ON DELETE CASCADE
            ON UPDATE CASCADE;

INSERT INTO EMPLOYEE(Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
	VALUES 
		('John','B','Smith',123456789,'1965-01-09','731 Fondren, Houston, TX','M',30000,333445555,5),
		('Alicia','J','Zelaya',999887777,'1968-01-19','3321 Castle, Spring TX','F',25000,987654321,4),
		('Ramesh','K','Narayan',666884444,'1962-09-15','975 Fire Oak, Humble TX','M',38000,333445555,5),
		('Joyce','A','English',453453453,'1972-07-31','5631 Rice, Houston TX','F',25000,333445555,5),
		('Ahmad','V','Jabbar',987987987,'1969-03-29','980 Dallas, Houston TX','M',25000,987654321,4);

INSERT INTO PROJECT(Pname, Pnumber, Plocation, Dnum)
	VALUES
		('ProductX',1,'Bellaire',5),
		('ProductY',2,'Sugarland',5),
		('ProductZ',3,'Houston',5),
		('Computerization',10,'Stafford',4),
		('Reorganization',20,'Houston',1),
		('Newbenefits',30,'Stafford',4);

INSERT INTO WORKS_ON
	VALUES
		(123456789,1,32.5),
		(123456789,2,7.5),
		(666884444,3,40.0),
		(453453453,1,20.0),
		(453453453,2,20.0),
		(333445555,2,10.0),
		(333445555,3,10.0),
		(333445555,10,10.0),
		(333445555,20,10.0),
		(999887777,30,30.0),
		(999887777,10,10.0),
		(987987987,10,35.0),
		(987987987,30,5.0),
		(987654321,30,20.0),
		(987654321,20,15.0),
		(888665555,20,null);

INSERT INTO DEPENDENT
	VALUES
		(333445555,'Alice','F','1986-04-04','Daughter'),
		(333445555,'John','M','1983-10-25','Son'),
		(333445555,'Joy','F','1958-05-03','Spouse'),
		(987654321,'Abner','M','1942-02-28','Spouse'),
		(123456789,'Michael','M','1988-01-04','Son'),
		(123456789,'Alice','F','1988-12-30','Daughter'),
		(123456789,'Elizabeth','F','1967-05-05','Spouse');
        
INSERT INTO DEPT_LOCATIONS
	VALUES
		(1,'Houston'),
		(4,'Stafford'),
		(5,'Bellaire'),
		(5,'Sugarland'),
		(5,'Houston');