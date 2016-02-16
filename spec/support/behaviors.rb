# Generic holder for integration test behaviors. This will refactor itself out soon.
module PlanHelpers
  def visit_new_plan_page(classroom)
    visit("/classrooms/#{classroom.id}/plans/new")
  end

  def visit_edit_plan_page(plan)
    visit("/plans/#{plan.id}/edit")
    expect(page).to have_content "Editing plan"
  end

  def click_on_create_plan
    click_on "Create Plan"
  end

  def parse_loan_table
    trs = all("table.table--loaned-assignments tbody tr")
    trs.map do |tr|
      { name: tr.find(".column--full-name").text,
        book_bag_global_id: tr.find(".column--book-bag-global-id").text,
        action: tr.find("a", text: "Process late return") }
    end
  end

  def make_late_return_for(name)
    table_data = parse_loan_table
    table_data.detect do |datum|
      datum[:name] == name
    end[:action].click
  end

  # @return [Hash] Mapping like so:
  # {12 => {name: "Serena Claussen", book_bag: "4"},
  #  14 => {name: "James Pryor", book_bag: "6"}}
  def parse_plan_form
    trs = all("tr[data-student-id]")
    map = {}
    trs.each_with_index do |el, idx|
      sid = el["data-student-id"]
      name_el = el.find(".student-name")
      select_el = el.find("select")
      map[sid] = { name: name_el.text, book_bag: select_el.value, row: el, index: idx }
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

  def within_latest_action_cell(&block)
    latest_actions_td = all("td[data-actions]").first
    within(latest_actions_td) do
      yield block
    end
  end

  def click_on_inventory_button
    within_latest_action_cell do
      click_on "Take Inventory"
    end
  end

  def expect_book_bag_checked_out_for(student)
    expect(page).to have_selector("tr[data-student-id='#{student.id}']")
  end

  def expect_no_book_bag_checked_out_for(student)
    expect(page).to_not have_selector("tr[data-student-id='#{student.id}']")
  end

  def parse_plan_table
    plan_matrix_trs = all(".plan-matrix tbody tr")
    plan_matrix_trs.map do |tr|
      OpenStruct.new(
        name: tr.find("th").text,
        bags: tr.all("td").map(&:text)
      )
    end
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

  # @return [Hash] Mapping like so:
  # [<name: "Serena Claussen", book_bag: "4", on_loan: true>,
  #  <name: "James Pryor", book_bag: "6", on_loan: false>]
  def parse_inventory_form
    trs = all("tr[data-student-id]")
    map = {}
    trs.each_with_index do |el, idx|
      sid = el["data-student-id"]
      name_el = el.find(".student-name")
      book_bag_el = el.find(".book-bag")
      on_loan = el.find(".on-loan input")
      map[sid] = { name: name_el.text,
                   book_bag: book_bag_el.text,
                   on_loan: on_loan.checked?,
                   index: idx }
    end
    map
  end
end

module BookBagHelpers
  # From the classroom page
  def click_on_edit_book_bag_link(book_bag)
    within(".book-bags-management") do
      click_on(book_bag.global_id)
    end
    expect(current_path).to eq edit_book_bag_path(book_bag)
  end
end
