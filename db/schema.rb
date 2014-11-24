# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141124002621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: true do |t|
    t.integer  "student_id"
    t.integer  "book_bag_id"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["book_bag_id"], name: "index_assignments_on_book_bag_id", using: :btree
  add_index "assignments", ["plan_id"], name: "index_assignments_on_plan_id", using: :btree
  add_index "assignments", ["student_id"], name: "index_assignments_on_student_id", using: :btree

  create_table "book_bags", force: true do |t|
    t.integer  "classroom_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "global_id"
  end

  add_index "book_bags", ["classroom_id"], name: "index_book_bags_on_classroom_id", using: :btree
  add_index "book_bags", ["global_id"], name: "index_book_bags_on_global_id", using: :btree

  create_table "classrooms", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  add_index "classrooms", ["name"], name: "index_classrooms_on_name", unique: true, using: :btree
  add_index "classrooms", ["school_id"], name: "index_classrooms_on_school_id", using: :btree

  create_table "plans", force: true do |t|
    t.string   "title"
    t.integer  "classroom_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["classroom_id"], name: "index_plans_on_classroom_id", using: :btree

  create_table "schools", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", force: true do |t|
    t.integer  "classroom_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "students", ["classroom_id"], name: "index_students_on_classroom_id", using: :btree

end
