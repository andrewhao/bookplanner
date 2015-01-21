require "spec_helper"

describe "inventory processing", type: :feature do
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
    @book_bags = FactoryGirl.create_list(:book_bag, 3,
                                   classroom: @classroom)
  end

  let(:current_plan) { Plan.last }
  let(:current_period) { current_plan.period }

  before do
    create_plan(@classroom)
  end

  describe "showing link to check-in on the classroom page" do
    context "for active plan" do
      it "links to inventory state new form" do
        visit("/classrooms/#{@classroom.id}")
        click_on "Take Inventory"
        expect(current_path).to match "inventory_states/new"
      end
    end

    context "for no active plans" do
      it "does not show the link" do
        FactoryGirl.create(:inventory_state, period: current_period)
        visit("/classrooms/#{@classroom.id}")
        expect(page).to_not have_content("Take inventory")
      end
    end
  end

  describe "while showing the UI" do
    before do
      visit_new_inventory_state_page(current_plan)
    end

    it "renders the page" do
      expect(page).to have_content("Take inventory for class #{@classroom.name}")
    end

    it "default checks all checkboxes" do
      # TODO/ahao We can describe this in a less brittle fashion.
      expect(page).to have_checked_field("inventory_state[assignments_attributes][0][on_loan]")
      expect(page).to have_checked_field("inventory_state[assignments_attributes][1][on_loan]")
    end

    it "persists the inventory state to the db" do
      click_on_take_inventory
      expect(page).to have_content("Checked in books successfully!")
    end
  end

  describe "for student who has not checked in a bag" do
    it "marks bag as out" do
      visit_new_inventory_state_page(current_plan)
      deselect_bag_check_in_for(@student)
      click_on_take_inventory
      expect_book_bag_checked_out_for(@student)
    end

    it "does not allow the student to be assigned the next plan around" do
      create_inventory_state_for(current_plan, students: [@student])
      expect_book_bag_checked_out_for(@student2)
      visit_new_plan_page(@classroom)
      expect_no_plan_row_for(@student2)
    end
  end

  describe "checking in assignments that have already been out for 1+ periods" do
    it "allows them to be checked in" do
      # Check in, sans student2
      create_inventory_state_for(current_plan, students: [@student])
      # 1 period passes
      create_plan(@classroom)
      click_on_inventory_button
      expect_inventory_row_for(@student2)
      click_on_take_inventory
      expect_no_book_bag_checked_out_for(@student2)
    end
  end
end
