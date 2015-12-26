require 'factory_girl'
require './spec/factories'

classroom = FactoryGirl.create :classroom
book_bags = FactoryGirl.create_list :book_bag, 5, classroom: classroom
students = FactoryGirl.create_list :student, 5, classroom: classroom

