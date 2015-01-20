require "spec_helper"

describe "plan editing", type: :feature do
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

  before do
    create_plan(@classroom)
  end

  let(:plan) { Plan.last }

  it "allows the user to swap the order of assignment", :focus do
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
    expect(page).to have_content "Plan successfully updated."
  end
end
