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
  end

  background do
    create_plan(@classroom)
  end

  let(:plan) { Plan.last }

  scenario "allows the user to swap the order of assignment" do
    visit_edit_plan_page(plan)
    form_map = parse_plan_form

    form_map.each do |sid, data|
      row_el = data[:row]
      new_val = data[:book_bag] == "1" ? "2" : "1"
      within(row_el) do
        select_el = find("select")
        select_el.select(new_val)
      end
    end

    click_on "Update Plan"
    expect(page).to have_content "Plan was successfully updated."
    click_on 'Edit'
    expect(page).to have_content 'Editing plan'

    form_map_updated = parse_plan_form
    expect(form_map.values.map { |d| d[:book_bag] }.reverse).to eq form_map_updated.values.map { |d| d[:book_bag] }
  end

  scenario 'allows the user to check in an old bag from a prior period and update the existing period with a new assignment' do
    skip 'not implemented'
  end
end
