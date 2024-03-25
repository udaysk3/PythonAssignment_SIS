import pyodbc
from datetime import datetime
from exceptions import TeacherNotFoundException, StudentNotFoundException, CourseNotFoundException, DuplicateEnrollmentException

class SISDatabase:
    def __init__(self, connection_string):
        self.connection_string = connection_string
        self.connection = None
        self.cursor = None

    def connect(self):
        self.connection = pyodbc.connect(self.connection_string)
        self.cursor = self.connection.cursor()

    def disconnect(self):
        self.connection.close()

    def initialize_database(self):
        self.connect()
        # Create tables if not exist
        self.cursor.execute('''
            IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Student')
            BEGIN
                CREATE TABLE Students (
                    student_id INT PRIMARY KEY,
                    first_name VARCHAR(50),
                    last_name VARCHAR(50),
                    date_of_birth DATE,
                    email VARCHAR(100),
                    phone_number VARCHAR(20)
                )
            END
            ''')

        self.cursor.execute('''
            IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Course')
            BEGIN
                CREATE TABLE Courses (
                    course_id INT PRIMARY KEY,
                    course_name VARCHAR(100),
                    credits INT,
                    teacher_id INT FOREIGN KEY REFERENCES Teacher(teacher_id)
                );
            END
            ''')

        self.cursor.execute('''
            IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Enrollment')
            BEGIN
                CREATE TABLE Enrollments (
                   enrollment_id INT PRIMARY KEY,
                    student_id INT FOREIGN KEY REFERENCES Students(student_id),
                    course_id INT FOREIGN KEY REFERENCES Courses(course_id),
                    enrollment_date DATE
                )
            END
            ''')

        self.cursor.execute('''
            IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Teacher')
            BEGIN
                CREATE TABLE Teacher (
                enrollment_id INT PRIMARY KEY,
                student_id INT FOREIGN KEY REFERENCES Students(student_id),
                course_id INT FOREIGN KEY REFERENCES Courses(course_id),
                enrollment_date DATE
                )
            END
            ''')

        self.cursor.execute('''
            IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Payment')
            BEGIN
                CREATE TABLE Payments (
                    payment_id INT PRIMARY KEY,
                    student_id INT FOREIGN KEY REFERENCES Students(student_id),
                    amount DECIMAL(10, 2),
                    payment_date DATE
                )
            END
            ''')

        self.connection.commit()
        self.disconnect()

    def execute_query(self, query):
        self.connect()
        self.cursor.execute(query)
        result = self.cursor.fetchall()
        self.disconnect()
        return result

    def execute_insert(self, query, values):
        self.connect()
        self.cursor.execute(query, values)
        self.connection.commit()
        self.disconnect()

    def execute_transaction(self, queries):
        self.connect()
        try:
            for query in queries:
                self.cursor.execute(query)
            self.connection.commit()
        except Exception as e:
            print("Transaction failed. Rolling back.")
            print("Error:", e) 
            self.connection.rollback()
        finally:
            self.disconnect()

    def build_dynamic_query(self, table, conditions=None, columns=None, sort_by=None):
        query = f"SELECT {', '.join(columns) if columns else '*'} FROM {table}"
        if conditions:
            query += f" WHERE {' AND '.join(conditions)}"
        if sort_by:
            query += f" ORDER BY {sort_by}"
        return query


# Task 8: Student Enrollment
def enroll_student(sisdb, student_data, course_ids):
        try:
            # Check if student already exists
            student_id = sisdb.execute_query("SELECT MAX(student_id) FROM Students")[0][0]
            if not student_id:
                raise StudentNotFoundException("Student not found in the system.")
            # Insert student data
            query = "INSERT INTO Students (student_id, first_name, last_name, date_of_birth, Email, phone_number) VALUES (?, ?, ?, ?, ?, ?)"
            values = (student_id + 1, student_data["first_name"], student_data["last_name"], student_data["date_of_birth"], student_data["Email"], student_data["phone_number"])
            sisdb.execute_insert(query, values)

            # Get the newly inserted student's ID
            student_id = sisdb.execute_query("SELECT MAX(student_id) FROM Students")[0][0]

            # Check if courses exist and enroll the student
            queries = []
            enrollment_id = sisdb.execute_query("SELECT MAX(enrollment_id) FROM Enrollments")[0][0]
            for course_id in course_ids:
                course_check_query = f"SELECT * FROM Courses WHERE course_id = {course_id}"
                if not sisdb.execute_query(course_check_query):
                    raise CourseNotFoundException("Course not found in the system.")
                
                # Check if the student is already enrolled in the course
                enrollment_check_query = f"SELECT * FROM Enrollments WHERE student_id = {student_id} AND course_id = {course_id}"
                if sisdb.execute_query(enrollment_check_query):
                    raise DuplicateEnrollmentException("Student is already enrolled in the course.")
                
                # Insert enrollment data
                enrollment_id += 1
                enrollment_insert_query = f"INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date) VALUES ({enrollment_id}, {student_id}, {course_id}, GETDATE())"
                queries.append(enrollment_insert_query)

            sisdb.execute_transaction(queries)

        except (StudentNotFoundException, CourseNotFoundException, DuplicateEnrollmentException) as e:
            print("Enrollment failed:", e)


# Task 9: Teacher Assignment
def assign_teacher(sis_db, teacher_data, course_code):
        try:
            # Check if teacher already exists
            teacher_id = sis_db.execute_query("SELECT MAX(teacher_id) FROM Teacher")[0][0]
            if not teacher_id:
                raise TeacherNotFoundException("Teacher not found in the system.")
            query = "INSERT INTO Teacher (teacher_id, first_name, last_name, Email) VALUES (?, ?, ?, ?)"
            values = (teacher_id + 1, teacher_data["first_name"], teacher_data["last_name"], teacher_data["Email"])
            sis_db.execute_insert(query, values)

            # Get the newly inserted teacher's ID
            teacher_id = sis_db.execute_query("SELECT MAX(teacher_id) FROM Teacher")[0][0]

            # Update the course with the assigned teacher
            query = f"UPDATE Courses SET teacher_id = ? WHERE course_id = ?"
            values = (teacher_id, course_code)
            sis_db.execute_insert(query, values)

        except TeacherNotFoundException as e:
            print("Teacher assignment failed:", e)

def record_payment(sis_db, student_id, amount, payment_date):
    try:
        # Check if student exists
        if not sis_db.execute_query(f"SELECT * FROM Students WHERE student_id = {student_id}"):
            raise StudentNotFoundException("Student not found in the system.")

        # Record the payment
        payment_id = sis_db.execute_query("SELECT MAX(payment_id) FROM Payments")[0][0]
        query = "INSERT INTO Payments (payment_id, student_id, Amount, payment_date) VALUES (?, ?, ?, ?)"
        values = (payment_id + 1, student_id, amount, payment_date)
        sis_db.execute_insert(query, values)

    except StudentNotFoundException as e:
        print("Payment recording failed:", e)

def generate_enrollment_report(sis_db, course_name):
    try:
        # Check if course exists
        course_id_result = sis_db.execute_query(f"SELECT course_id FROM Courses WHERE course_name = '{course_name}'")
        if not course_id_result:
            raise CourseNotFoundException("Course not found in the system.")
        course_id = course_id_result[0][0]

        # Generate enrollment report
        query = sis_db.build_dynamic_query("Enrollments", conditions=[f"course_id = {course_id}"])
        return sis_db.execute_query(query)

    except CourseNotFoundException as e:
        print("Enrollment report generation failed:", e)

# Main Program
if __name__ == "__main__":
    # Database connection details
    connection_string = 'DRIVER={SQL Server};SERVER=UDAYSK\SQLEXPRESS;DATABASE=SISDB;Trusted_Connection=yes;'

    # Initialize SIS database
    sis_db = SISDatabase(connection_string)
    sis_db.initialize_database()

    # Task 8: Student Enrollment
    student_data = {
        "first_name": "John",
        "last_name": "Doe",
        "date_of_birth": datetime(1995, 8, 15),
        "Email": "john.doe@example.com",
        "phone_number": "123-456-7890"
    }
    course_ids = [1, 2]  

    # Enroll student
    enroll_student(sis_db, student_data, course_ids)

    # Task 9: Teacher Assignment
    teacher_data = {
        "first_name": "Sarah",
        "last_name": "Smith",
        "Email": "sarah.smith@example.com"
    }
    course_code = "1"  # Course code for Advanced Database Management

    # Assign teacher
    assign_teacher(sis_db, teacher_data, course_code)

    # Task 10: Payment Record
    student_id = 10  
    amount = 500.00
    payment_date = datetime(2023, 4, 10)

    # Record payment
    record_payment(sis_db, student_id, amount, payment_date)

    # Task 11: Enrollment Report Generation
    course_name = "Introduction to Programming"

    # Generate enrollment report
    enrollment_report = generate_enrollment_report(sis_db, course_name)
    print("Enrollment Report for", course_name)
    print(enrollment_report)

