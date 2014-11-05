# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#

   Category.create(title: 'Tech')
   Category.create(title: 'Fashion', gender: "male")
   Category.create(title: 'Fashion', gender: "female")
   Category.create(title: 'Vehicle')
   Category.create(title: 'Sport')
   Category.create(title: 'Decor')
   Category.create(title: 'Food')
   Category.create(title: 'Apps', parent_id:1)
   Category.create(title: 'Audio', parent_id:1) 
   Category.create(title: 'Cameras', parent_id:1)
   Category.create(title: 'Phones', parent_id:1)
   Category.create(title: 'Computers', parent_id:1)
   Category.create(title: 'Gadgets', parent_id:1)
   Category.create(title: 'TVs', parent_id:1)
   Category.create(title: 'Shoes', gender: "male", parent_id:2)
   Category.create(title: 'Shirts', gender: "male", parent_id:2)
   Category.create(title: 'Pants', gender: "male", parent_id:2)
   Category.create(title: 'Jewelry', gender: "male", parent_id:2)
   Category.create(title: 'Jackets', gender: "male", parent_id:2)
   Category.create(title: 'Bags', gender: "male", parent_id:2)
   Category.create(title: 'Accessories', gender: "male", parent_id:2)
   Category.create(title: 'Shoes', gender: "female", parent_id:3)
   Category.create(title: 'Shirts', gender: "female", parent_id:3)
   Category.create(title: 'Pants', gender: "female", parent_id:3)
   Category.create(title: 'Jewelry', gender: "female", parent_id:3)
   Category.create(title: 'Lingerie', gender: "male", parent_id:3)
   Category.create(title: 'Jackets', gender: "female", parent_id:3)
   Category.create(title: 'Bags', gender: "female", parent_id:3)
   Category.create(title: 'Accessories', gender: "female", parent_id:3)
   Category.create(title: 'Cars', parent_id:4)
   Category.create(title: 'Motorcycles', parent_id:4)
   Category.create(title: 'Water', parent_id:4)
   Category.create(title: 'Soccer', parent_id:5)
   Category.create(title: 'Baseball', parent_id:5)
   Category.create(title: 'Football', parent_id:5)
   Category.create(title: 'Basketball', parent_id:5)
   Category.create(title: 'Golf', parent_id:5)
   Category.create(title: 'Kitchen', parent_id:6)
   Category.create(title: 'Livingroom', parent_id:6)
   Category.create(title: 'Dorm', parent_id:6)
   Category.create(title: 'Bathroom', parent_id:6)
   Category.create(title: 'Bedroom', parent_id:6)
   Category.create(title: 'Outdoor', parent_id:6)
   Category.create(title: 'Alcohol', parent_id:7)
   Category.create(title: 'Meals', parent_id:7)
   Category.create(title: 'Snacks', parent_id:7)
   Category.create(title: 'Desserts', parent_id:7)







