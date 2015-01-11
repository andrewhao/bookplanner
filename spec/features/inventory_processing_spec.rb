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
    @book_bag = FactoryGirl.create(:book_bag,
                                   global_id: "1",
                                   classroom: @classroom)
    @book_bag2 = FactoryGirl.create(:book_bag,
                                    global_id: "2",
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

    xit "previews a book bag to a student for a classroom" do
      within "[data-student-id='#{@student.id}']" do
        expect(page).to have_select("plan_assignments_attributes_0_book_bag_id",
                                    selected: @book_bag.global_id)
      end

      within "[data-student-id='#{@student2.id}']" do
        expect(page).to have_select("plan_assignments_attributes_1_book_bag_id",
                                    selected: @book_bag2.global_id)
      end
    end

    xit "persists the plan to the db" do
      click_on_create_plan
      expect(page).to have_content("Plan was successfully created.")
      expect(page).to have_content(Plan.last.name)
    end
  end
end
