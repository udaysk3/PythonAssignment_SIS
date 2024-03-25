from datetime import datetime
from main import Student, Course, Teacher, Enrollment, Payment

class SIS:
    def __init__(self):
        self.students = []
        self.courses = []
        self.teachers = []
        self.enrollments = []
        self.payments = []

    def enroll_student_in_course(self, student, course):
        enrollment = Enrollment(student.student_id, course.course_id, datetime.now())
        self.enrollments.append(enrollment)
        student.enrollments.append(enrollment)
        course.enrollments.append(enrollment)

    def assign_teacher_to_course(self, teacher, course):
        course.assign_teacher(teacher)
        teacher.assigned_courses.append(course)

    def record_payment(self, student, amount, payment_date):
        payment = Payment(student.student_id, amount, payment_date)
        self.payments.append(payment)
        student.payments.append(payment)

    def generate_enrollment_report(self, course):
        enrolled_students = [enrollment.student_id for enrollment in course.enrollments]
        return enrolled_students

    def generate_payment_report(self, student):
        student_payments = [(payment.amount, payment.payment_date) for payment in student.payments]
        return student_payments

    def calculate_course_statistics(self, course):
        num_enrollments = len(course.enrollments)
        total_payments = sum(payment.amount for payment in self.payments if payment.student_id in [enrollment.student_id for enrollment in course.enrollments])
        return num_enrollments, total_payments
