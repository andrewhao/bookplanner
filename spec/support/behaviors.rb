# Generic holder for integration test behaviors. This will refactor itself out soon.
module PlanHelpers
  def visit_new_plan_page(classroom)
    visit("/classrooms/#{classroom.id}/plans/new")
  end

  def visit_edit_plan_page(plan)
    visit("/plans/#{plan.id}/edit")
  end

  def click_on_create_plan
    click_on "Create Plan"
  end

  # @return [Hash] Mapping like so:
  # {12 => {name: "Serena Claussen", book_bag: "4"},
  #  14 => {name: "James Pryor", book_bag: "6"}}
  def parse_plan_form
    trs = all("tr[data-student-id]")
    map = {}
    trs.each do |el|
      sid = el['data-student-id']
      name_el = el.find('.student-name')
      select_el = el.find('select')
      map[sid] = {name: name_el.text, book_bag: select_el.value, row: el}
    end
    map
  end

  def create_plan(classroom)
    visit_new_plan_page(classroom)
    click_on_create_plan
    # Add an expectation to test with implicit waits.
    expect(current_path).to match "/classrooms/#{classroom.id}"
  end

  def expect_plan_row_for(student)
    expect(page).to have_selector("tr[data-student-id='#{student.id}']")
  end

  def expect_no_plan_row_for(student)
    expect(page).to_not have_selector("tr[data-student-id='#{student.id}']")
  end

end

module ClassroomHelpers
  def add_classroom(class_name)
    add_school("Joshua Tree Middle School")
    visit("/classrooms")
    click_on("New Classroom")
    fill_in("Name", with: class_name)
    select("Joshua Tree Middle School", from: "School")
    click_on("Create Classroom")
  end

  def click_on_inventory_button
    click_on "Check in books"
  end
end

module SchoolHelpers
  def add_school(name)
    visit("/schools")
    click_on("New School")
    fill_in("Name", with: name)
    click_on("Create School")
  end
end

module InventoryStateHelpers
  def visit_new_inventory_state_page(plan)
    c = plan.classroom
    visit("/classrooms/#{c.id}/inventory_states/new")
  end

  def click_on_take_inventory
    click_on("Take Inventory")
  end

  def expect_inventory_row_for(student)
    expect(page).to have_selector("tr[data-student-id='#{student.id}']")
  end

  def expect_no_inventory_row_for(student)
    expect(page).to_not have_selector("tr[data-student-id='#{student.id}']")
  end


  def select_bag_check_in_for(student)
    within("tr[data-student-id='#{student.id}']") do
      check("On loan?")
    end
  end

  def deselect_bag_check_in_for(student)
    within("tr[data-student-id='#{student.id}']") do
      uncheck("On loan?")
    end
  end

  def deselect_all_bags
    bags = all("input[type='checkbox']")
    bags.map(&:click)
  end

  # @param [Plan] plan
  # @param [Array<Student>] students Students that should be checked in. Any students who
  #   do not show up in this array are not checked in.
  def create_inventory_state_for(plan, students: [])
    visit_new_inventory_state_page(plan)

    if students.any?
      deselect_all_bags
      students.each do |s|
        select_bag_check_in_for(s)
      end
    end

    click_on_take_inventory
  end
end
