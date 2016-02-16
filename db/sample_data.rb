require "factory_girl"
require "./spec/factories"

classroom = FactoryGirl.create :classroom
book_bags = FactoryGirl.create_list :book_bag, 3, classroom: classroom
students = FactoryGirl.create_list :student, 3, classroom: classroom
period = FactoryGirl.create(:period, classroom: classroom)
pg = PlanGenerator.new(classroom.eligible_students, classroom.available_book_bags)
assignments = pg.generate
FactoryGirl.create(:plan, period: period, assignments: assignments)
FactoryGirl.create(:inventory_state, period: period, assignments: assignments.take(2))
