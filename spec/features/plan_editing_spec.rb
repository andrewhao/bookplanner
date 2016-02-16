require "spec_helper"

feature "plan editing", type: :feature do
  before do
    @classroom = FactoryGirl.create(:classroom, name: "Mrs. Wu")
    @student = FactoryGirl.create(:student,
                                  first_name: "Jane",
                                  last_name: "Lee",
                                  classroom: @classroom)
    @student2 = FactoryGirl.create(:student,
                                   first_name: "Zhang",
                                   last_name: "Wu",
                                   classroom: @classroom)
    @book_bag = FactoryGirl.create(:book_bag,
                                   global_id: "1",
                                   classroom: @classroom)
    @book_bag2 = FactoryGirl.create(:book_bag,
                                    global_id: "2",
                                    classroom: @classroom)
    @book_bag3 = FactoryGirl.create(:book_bag,
                                    global_id: "3",
                                    classroom: @classroom)
  end

  background do
    create_plan(@classroom)
  end

  let(:plan) { Plan.last }

  scenario 'prevents duplicate assignments in plan editing' do
    visit_edit_plan_page(plan)
    form_map = parse_plan_form

    form_map.each do |sid, data|
      row_el = data[:row]
      within(row_el) do
        select_el = find("select")
        select_el.select("1")
      end
    end
    click_on "Update Plan"

    expect(page).to have_content 'This is a duplicate book bag.'
  end

  scenario "allows the user to swap the order of assignment" do
    visit_edit_plan_page(plan)
    form_map = parse_plan_form

    book_bag_ids = form_map.values.reduce([]) { |acc, row| acc << row[:book_bag] }

    form_map.each do |sid, data|
      row_el = data[:row]
      new_val = (book_bag_ids - [data[:book_bag]]).first
      within(row_el) do
        select_el = find("select")
        select_el.select(new_val)
      end
    end

    click_on "Update Plan"
    expect(page).to have_content "Plan was successfully updated."

    within_latest_action_cell do
      click_on 'More'
      click_on 'Edit Plan'
    end

    expect(page).to have_content 'Editing plan'

    form_map_updated = parse_plan_form
    expect(form_map.values.map { |d| d[:book_bag] }.reverse).to eq form_map_updated.values.map { |d| d[:book_bag] }
  end

  scenario 'allows the user to check in an old bag from a prior period and update the existing period with a new assignment' do
    create_inventory_state_for(plan, students: [@student])
    create_plan(@classroom)
    visit_edit_plan_page(Plan.last)
    expect(page).to have_content 'Assignments still out on loan'
    expect(page).to have_selector '.table--loaned-assignments'
    outstanding_assignment = Assignment.find_by(student_id: @student2.id)
    expected_bag_id = outstanding_assignment.book_bag.global_id == "1" ? "2" : "1"
    make_late_return_for(@student2.full_name)
    expect(current_path).to include "/classrooms/#{@classroom.to_param}"
    expect(page).to have_content "Zhang Wu newly assigned Book Bag"
    expect(parse_loan_table).to be_empty
  end
end
