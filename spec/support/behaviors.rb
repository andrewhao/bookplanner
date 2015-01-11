# Generic holder for integration test behaviors. This will refactor itself out soon.
module PlanHelpers
  def visit_new_plan_page(classroom)
    visit("/classrooms/#{classroom.id}/plans/new")
  end

  def click_on_create_plan
    click_on "Create Plan"
  end

  def create_plan(classroom)
    visit_new_plan_page(classroom)
    click_on_create_plan
    # Add an expectation to test with implicit waits.
    expect(current_path).to match "/classrooms/#{classroom.id}"
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

  def create_inventory_state_for(plan)
    visit_new_inventory_state_page(plan)
    click_on("Take Inventory")
  end
end
