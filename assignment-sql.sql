
--TASK 1
--1 Create the database named "SISDB
Create Database SISDB;

use SISDB;

--2 Define the schema for the Students, Courses, Enrollments, Teacher, and Payments tables based on the provided schema. Write SQL scripts to create the mentioned tables with appropriate data  types, constraints, and relationships. 
--a. Students 
--b. Courses
--c. Enrollments 
--d. Teacher 
--e. Payments
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    email VARCHAR(100),
    phone_number VARCHAR(20)
);

CREATE TABLE Teacher (
    teacher_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);


CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    credits INT,
    teacher_id INT FOREIGN KEY REFERENCES Teacher(teacher_id)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT FOREIGN KEY REFERENCES Students(student_id),
    course_id INT FOREIGN KEY REFERENCES Courses(course_id),
    enrollment_date DATE
);


CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    student_id INT FOREIGN KEY REFERENCES Students(student_id),
    amount DECIMAL(10, 2),
    payment_date DATE
);

--3. Create an ERD (Entity Relationship Diagram) for the database

--4 . Create appropriate Primary Key and Foreign Key constraints for referential integrity.
--5 Insert at least 10 sample records into each of the following tables.
INSERT INTO Students (student_id, first_name, last_name, date_of_birth, email, phone_number)
VALUES
(1, 'Udaysk', 'Lastname1', '1990-01-15', 'udaysk@example.com', '555-1234'),
(2, 'Harsha', 'Patnaik', '1992-05-20', 'harsha.patnaik@example.com', '555-5678'),
(3, 'Hemanth', 'Kumar', '1988-09-10', 'hemanth.kumar@example.com', '555-9876'),
(4, 'Prabhas', 'Lastname4', '1995-03-25', 'prabhas@example.com', '555-4321'),
(5, 'Deepak', 'Lastname5', '1993-11-08', 'deepak@example.com', '555-8765'),
(6, 'Sudheer', 'Lastname6', '1997-07-12', 'sudheer@example.com', '555-2109'),
(7, 'Sunil', 'Lastname7', '1991-02-18', 'sunil@example.com', '555-6543'),
(8, 'Anil', 'Lastname8', '1994-06-30', 'anil@example.com', '555-1098'),
(9, 'Raju', 'Lastname9', '1989-12-05', 'raju@example.com', '555-5432'),
(10, 'Ravi', 'Lastname10', '1996-08-22', 'ravi@example.com', '555-9870'),
(11, 'Vinay', 'Lastname11', '1998-04-14', 'vinay@example.com', '555-1230'),
(12, 'Sekhar', 'Lastname12', '1997-11-02', 'sekhar@example.com', '555-4567');

INSERT INTO Courses (course_id, course_name, credits, teacher_id)
VALUES
(1, 'Introduction to Programming', 3, 101),
(2, 'Database Management', 4, 102),
(3, 'Web Development', 3, 103),
(4, 'Data Science Fundamentals', 4, 104),
(5, 'Software Engineering Principles', 3, 105);

INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date)
VALUES
(1, 1, 1, '2024-02-27'),
(2, 2, 3, '2024-02-28'),
(3, 3, 2, '2024-02-29'),
(4, 4, 4, '2024-03-01');

INSERT INTO Teacher (teacher_id, first_name, last_name, email)
VALUES
(101, 'John', 'Smith', 'john.smith@example.com'),
(102, 'Jane', 'Doe', 'jane.doe@example.com'),
(103, 'Michael', 'Johnson', 'michael.j@example.com'),
(104, 'Emily', 'Williams', 'emily.w@example.com'),
(105, 'David', 'Brown', 'david.b@example.com');

INSERT INTO Payments (payment_id, student_id, amount, payment_date)
VALUES
(1, 1, 100.00, '2024-03-03'),
(2, 2, 75.50, '2024-03-04'),
(3, 3, 120.00, '2024-03-05'),
(4, 4, 90.25, '2024-03-06'),
(5, 5, 150.50, '2024-03-07');

SELECT * FROM STUDENTS;
SELECT * FROM Teacher;
SELECT * FROM Courses;
SELECT * FROM Payments;
SELECT * FROM Enrollments;

--Task 2 

--1 . Write an SQL query to insert a new student into the "Students" table with the following details:
--a. First Name: John
--b. Last Name: Doe
--c. Date of Birth: 1995-08-15
--d. Email: john.doe@example.com
--e. Phone Number: 1234567890
INSERT INTO Students (student_id, first_name, last_name, date_of_birth, email, phone_number)
VALUES (13, 'John', 'Doe', '1995-08-15', 'john.doe@example.com', '1234567890');

--2 Write an SQL query to enroll a student in a course. Choose an existing student and course and insert a record into the "Enrollments" table with the enrollment date.
INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date)
VALUES (7, 1, 2, '2024-03-01');

--3 Update the email address of a specific teacher in the "Teacher" table. Choose any teacher and modify their email address
UPDATE TEACHER 
SET EMAIL = 'TEACHER@GMAIL.COM'
WHERE teacher_id = 105

--4  Write an SQL query to delete a specific enrollment record from the "Enrollments" table. Select an enrollment record based on the student and course.
DELETE FROM Enrollments
WHERE STUDENT_ID = 1 AND course_id = 1

--5 Update the "Courses" table to assign a specific teacher to a course. Choose any course and teacher from the respective tables.
UPDATE COURSES
SET teacher_id = 104
WHERE course_id = 3

--6 Delete a specific student from the "Students" table and remove all their enrollment records  from the "Enrollments" table. Be sure to maintain referential integrity.
BEGIN TRANSACTION;

DELETE FROM Enrollments
WHERE student_id = 5;

DELETE FROM Payments
WHERE student_id = 5;

DELETE FROM Students
WHERE student_id = 5;

COMMIT;

--7 Update the payment amount for a specific payment record in the "Payments" table. Choose any  payment record and modify the payment amount.
UPDATE Payments
SET AMOUNT = 300
WHERE payment_date BETWEEN '2024-03-04' AND '2024-03-06'


--Task 3. Aggregate functions, Having, Order By, GroupBy and Joins:
--1. Write an SQL query to calculate the total payments made by a specific student. You will need to  join the "Payments" table with the "Students" table based on the student's ID
SELECT student_id, SUM(amount) AS total_payments
FROM Payments
WHERE student_id = 1
GROUP BY student_id;

--2 Write an SQL query to retrieve a list of courses along with the count of students enrolled in each  course. Use a JOIN operation between the "Courses" table and the "Enrollments" table.

SELECT COURSES.COURSE_NAME, COUNT(ENROLLMENTS.STUDENT_ID) NUMBER_OF_STUDENTS
FROM COURSES LEFT JOIN ENROLLMENTS
ON COURSES.COURSE_ID = ENROLLMENTS.COURSE_ID
GROUP BY COURSES.COURSE_ID, COURSES.COURSE_NAME;

--3 Write an SQL query to find the names of students who have not enrolled in any course. Use a  LEFT JOIN between the "Students" table and the "Enrollments" table to identify students  without enrollments
SELECT S.STUDENT_ID, S.FIRST_NAME, S.LAST_NAME
FROM Students S
LEFT JOIN Enrollments E ON S.student_id=E.student_id
WHERE E.student_id IS NULL;

--4 Write an SQL query to retrieve the first name, last name of students, and the names of the  courses they are enrolled in. Use JOIN operations between the "Students" table and the  "Enrollments" and "Courses" tables.
SELECT s.student_id, s.first_name, c.course_name 
FROM Students S
JOIN Enrollments E ON S.student_id = E.student_id
JOIN Courses C ON E.course_id = C.course_id

--5 Create a query to list the names of teachers and the courses they are assigned to. Join the  "Teacher" table with the "Courses" table
SELECT T.FIRST_NAME TEACHER, C.COURSE_NAME
FROM Courses C
JOIN Teacher T
ON C.teacher_id = T.teacher_id

SELECT T.FIRST_NAME TEACHER, C.COURSE_NAME
FROM tEACHER T
JOIN COURSES C
ON C.teacher_id = T.teacher_id

--6 Retrieve a list of students and their enrollment dates for a specific course. You'll need to join the  "Students" table with the "Enrollments" and "Courses" tables
SELECT s.FIRST_NAME, E.enrollment_date, c.course_name 
FROM Students S
JOIN Enrollments E ON S.student_id = E.student_id
JOIN Courses C ON E.course_id = C.course_id

--7 Find the names of students who have not made any payments. Use a LEFT JOIN between the "Students" table and the "Payments" table and filter for students with NULL payment records.
SELECT s.FIRST_NAME,S.LAST_NAME
FROM Students S
LEFT JOIN Payments P ON S.student_id = P.student_id
WHERE P.payment_id IS NULL;

--8. Write a query to identify courses that have no enrollments. You'll need to use a LEFT JOIN between the "Courses" table and the "Enrollments" table and filter for courses with NULL enrollment records
SELECT c.course_id,c.course_name
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
WHERE e.course_id IS NULL;

--9 Identify students who are enrolled in more than one course. Use a self-join on the "Enrollments" table to find students with multiple enrollment records.
INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date)
VALUES (8, 1, 2, '2024-03-01');

SELECT DISTINCT E.STUDENT_ID, COUNT(E.COURSE_ID) COUNTOFCOURSES
FROM ENROLLMENTS E
JOIN ENROLLMENTS C
ON E.STUDENT_ID = C.STUDENT_ID 
GROUP BY E.STUDENT_ID, E.COURSE_ID
HAVING COUNT(E.COURSE_ID) > 1;

--10  Find teachers who are not assigned to any courses. Use a LEFT JOIN between the "Teacher" table and the "Courses" table and filter for teachers with NULL course assignment
SELECT T.TEACHER_ID, T.FIRST_NAME, T.LAST_NAME
FROM TEACHER T
LEFT JOIN COURSES C
ON T.TEACHER_ID = C.TEACHER_ID
WHERE C.TEACHER_ID IS NULL;

--TASK 4 
--1 Write an SQL query to calculate the average number of students enrolled in each course. Use aggregate functions and subqueries to achieve this
SELECT E.COURSE_ID, COUNT(E.STUDENT_id)
FROM Enrollments E
GROUP BY E.course_id

SELECT AVG(enrollment_count) AS avg_students_per_course
FROM (SELECT course_id, COUNT(DISTINCT student_id) AS enrollment_count
      FROM Enrollments
      GROUP BY course_id) AS CourseEnrollmentCounts;

--2 Identify the student(s) who made the highest payment. Use a subquery to find the maximum payment amount and then retrieve the student(s) associated with that amount
SELECT STUDENT_ID
FROM PAYMENTS
WHERE AMOUNT = ( 
SELECT MAX(AMOUNT) FROM Payments)

--3 Retrieve a list of courses with the highest number of enrollments. Use subqueries to find the course(s) with the maximum enrollment count.
SELECT COURSE_ID, COUNT(student_id) FROM Enrollments
group by course_id
having COUNT(student_id) = (
SELECT MAX(ENROLLMENTCOUNT) FROM (
SELECT COURSE_ID, COUNT(student_id) ENROLLMENTCOUNT 
FROM Enrollments 
group by course_id
) ENROLLMENTCOUNT);

--4 Calculate the total payments made to courses taught by each teacher. Use subqueries to sum payments for each teacher's courses
SELECT t.teacher_id, t.first_name, t.last_name, SUM(p.amount) AS total_payments
FROM Teacher t
JOIN Courses c ON t.teacher_id = c.teacher_id
JOIN Enrollments e ON c.course_id = e.course_id
JOIN Payments p ON e.student_id = p.student_id
GROUP BY t.teacher_id, t.first_name, t.last_name;

--5 Identify students who are enrolled in all available courses. Use subqueries to compare a student's enrollments with the total number of courses.
SELECT STUDENT_ID, COUNT(COURSE_ID)
FROM Enrollments
GROUP BY student_id
HAVING COUNT(COURSE_ID) = (SELECT COUNT(DISTINCT COURSE_ID) FROM Courses)

--6 Retrieve the names of teachers who have not been assigned to any courses. Use subqueries to  find teachers with no course assignments
SELECT teacher_id, first_name, last_name
FROM Teacher
WHERE teacher_id NOT IN (SELECT DISTINCT teacher_id FROM Courses);

--7 Calculate the average age of all students. Use subqueries to calculate the age of each student based on their date of birth
SELECT AVG(DATEDIFF(YEAR, date_of_birth, GETDATE())) AS average_age
FROM Students;

--8 Identify courses with no enrollments. Use subqueries to find courses without enrollment records
SELECT COURSE_ID 
FROM COURSES
WHERE course_id NOT IN (SELECT course_id FROM Enrollments);

--9. Calculate the total payments made by each student for each course they are enrolled in. Use subqueries and aggregate functions to sum payments.
SELECT e.student_id, e.course_id,
  (SELECT SUM(amount) FROM Payments p WHERE p.student_id = e.student_id) AS total_payments
FROM Enrollments e;

--10 Identify students who have made more than one payment. Use subqueries and aggregate functions to count payments per student and filter for those with counts greater than one
SELECT STUDENT_ID, FIRST_NAME, LAST_NAME
FROM STUDENTS
WHERE STUDENT_ID IN (
SELECT student_id
FROM Payments
GROUP BY student_id
HAVING COUNT(payment_id) > 1
);

--11 Write an SQL query to calculate the total payments made by each student. Join the "Students" table with the "Payments" table and use GROUP BY to calculate the sum of payments for each student
SELECT S.STUDENT_ID, SUM(P.AMOUNT)
FROM Students S
JOIN Payments P
ON S.student_id = P.payment_id
GROUP BY S.student_id

--12. Retrieve a list of course names along with the count of students enrolled in each course. Use JOIN operations between the "Courses" table and the "Enrollments" table and GROUP BY to count enrollments
SELECT C.COURSE_ID, C.course_NAME, COUNT(E.STUDENT_ID) STUDENTCOUNT
FROM Courses C
JOIN ENROLLMENTS E
ON C.course_id = E.course_id
GROUP BY C.COURSE_ID, C.course_NAME

--13  Calculate the average payment amount made by students. Use JOIN operations between the "Students" table and the "Payments" table and GROUP BY to calculate the average.
SELECT S.STUDENT_ID, AVG(P.AMOUNT) AVGAMOUNT
FROM Students S
JOIN Payments P
ON S.student_id = P.payment_id
GROUP BY S.student_id

SELECT AVG(amount) AS average_payment_amount
FROM Payments;