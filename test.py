class Student:
    category = "Student"

    @classmethod
    def info(cls):
        print(f"This method is of class {cls.category}")

# Calling the class method correctly on the class itself
Student.info()
