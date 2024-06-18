#nested class

class Zoo:
  def __init__(self):
    self.animals = []

  def add_animals(self,name,species):
    animal = self.Animal(name,species)
    self.animals.append(animal)

  class Animal:
    def __init__(self,name,species):
      self.name = name
      self.species = species

    def display_info(self):
      print(f"Name: {self.name} and Species: {self.species}")

my_zoo = Zoo()

my_zoo.add_animals("Lion", "Mammal")

my_zoo.add_animals("Snake", "Reptile")


my_zoo.add_animals("Eagle", "Bird")

for animal in my_zoo.animals:
  animal.display_info()

    