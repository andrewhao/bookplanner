require "spec_helper"

describe "plan creation", type: :feature do
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

  before do
    create_plan(@classroom)
    @plan = Plan.last
  end

  describe "showing link to check-in on the classroom page" do
    context "for active plan" do
      it "shows the link" do
        visit("/classrooms/#{@classroom.id}")
        expect(page).to have_content("Check in books")
      end
    end

    context "for no active plans" do
      it "does not show the link" do
        FactoryGirl.create(:inventory_state, period: @plan.period)
        visit("/classrooms/#{@classroom.id}")
        expect(page).to_not have_content("Check in books")
      end
    end
  end

  describe "while showing the UI" do
    before do
      visit_new_inventory_state_page(@plan)
    end

    it "renders the page" do
      expect(page).to have_content("Take inventory for class #{@classroom.name}")
    end

    it "default checks all checkboxes" do
      # TODO/ahao We can describe this in a less brittle fashion.
      expect(page).to have_checked_field("inventory_state[assignments_attributes][0][on_loan]")
      expect(page).to have_checked_field("inventory_state[assignments_attributes][1][on_loan]")
    end

    context "for student who has not checked in a bag" do
      it "marks bag as out" do
        deselect_bag_check_in_for(@student)
        click_on_take_inventory
        expect(page).to have_content("#{@student.full_name} still has")
      end

      it "does not allow the student to be assigned the next plan around" do
        create_inventory_state_for(@plan, students: [@student])
        expect(page).to have_content("#{@student2.full_name} still has")
        visit_new_plan_page(@classroom)
        expect(page).to_not have_content("tr[data-student-id='#{@student2.id}']")
      end
    end

    it "persists the inventory state to the db" do
      click_on_take_inventory
      expect(page).to have_content("Checked in books successfully!")
    end
  end
end
