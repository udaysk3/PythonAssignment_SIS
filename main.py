from datetime import datetime

class Student:
    def __init__(self, student_id, first_name, last_name, dob, email, phone_number):
        self.student_id = student_id
        self.first_name = first_name
        self.last_name = last_name
        self.dob = dob
        self.email = email
        self.phone_number = phone_number
        self.enrollments = []
        self.payments = []
    
    def enroll_in_course(self, course):
        enrollment = Enrollment(self.student_id, course.course_id, datetime.now())
        self.enrollments.append(enrollment)
    
    def update_student_info(self, first_name, last_name, dob, email, phone_number):
        self.first_name = first_name
        self.last_name = last_name
        self.dob = dob
        self.email = email
        self.phone_number = phone_number
    
    def make_payment(self, amount, payment_date):
        payment = Payment(self.student_id, amount, payment_date)
        self.payments.append(payment)
    
    def display_student_info(self):
        print(f"Student ID: {self.student_id}")
        print(f"Name: {self.first_name} {self.last_name}")
        print(f"Date of Birth: {self.dob}")
        print(f"Email: {self.email}")
        print(f"Phone Number: {self.phone_number}")
    
    def get_enrolled_courses(self):
        return [enrollment.course_id for enrollment in self.enrollments]
    
    def get_payment_history(self):
        return [(payment.amount, payment.payment_date) for payment in self.payments]

class Course:
    def __init__(self, course_id, course_name, course_code, instructor_name):
        self.course_id = course_id
        self.course_name = course_name
        self.course_code = course_code
        self.instructor_name = instructor_name
        self.enrollments = []
    
    def assign_teacher(self, teacher):
        self.instructor_name = teacher.full_name()
    
    def update_course_info(self, course_code, course_name, instructor_name):
        self.course_code = course_code
        self.course_name = course_name
        self.instructor_name = instructor_name
    
    def display_course_info(self):
        print(f"Course ID: {self.course_id}")
        print(f"Name: {self.course_name}")
        print(f"Code: {self.course_code}")
        print(f"Instructor: {self.instructor_name}")
    
    def get_enrollments(self):
        return [enrollment.student_id for enrollment in self.enrollments]
    
    def get_teacher(self):
        return self.instructor_name

class Enrollment:
    def __init__(self, student_id, course_id, enrollment_date):
        self.enrollment_id = hash((student_id, course_id, enrollment_date))
        self.student_id = student_id
        self.course_id = course_id
        self.enrollment_date = enrollment_date

class Teacher:
    def __init__(self, teacher_id, first_name, last_name, email):
        self.teacher_id = teacher_id
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.assigned_courses = []
    
    def update_teacher_info(self, first_name, last_name, email):
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
    
    def display_teacher_info(self):
        print(f"Teacher ID: {self.teacher_id}")
        print(f"Name: {self.first_name} {self.last_name}")
        print(f"Email: {self.email}")
    
    def get_assigned_courses(self):
        return [course.course_id for course in self.assigned_courses]

    def full_name(self):
        return f"{self.first_name} {self.last_name}"

class Payment:
    def __init__(self, student_id, amount, payment_date):
        self.payment_id = hash((student_id, amount, payment_date))
        self.student_id = student_id
        self.amount = amount
        self.payment_date = payment_date


if __name__ == "__main__":
    student1 = Student(1, "John", "Doe", datetime(1995, 8, 15), "john.doe@example.com", "123-456-7890")
    course1 = Course(101, "Introduction to Programming", "CS101", "Dr. Smith")
    teacher1 = Teacher(1, "Dr.", "Smith", "dr.smith@example.com")
    payment1 = Payment(1, 500.00, datetime(2023, 4, 10))

    # Enroll student in course
    student1.enroll_in_course(course1)
    print(student1.get_enrolled_courses())

    # Update student info
    student1.update_student_info("John", "Doe", datetime(1995, 8, 15), "john.doe@example.com", "123-456-7890")
    student1.display_student_info()

    # Make payment
    student1.make_payment(500.00, datetime(2023, 4, 10))
    print(student1.get_payment_history())

    # Assign teacher to course
    course1.assign_teacher(teacher1)
    print(course1.get_teacher())
