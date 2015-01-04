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

  it "can be created from a classroom page" do
    visit("/classrooms")
    click_on("Show")
    expect(page).to have_content("Classroom: Mrs. Wu")
    expect(page).to have_content("Create Plan")
    click_on("Create Plan")
    expect(page).to have_content("New plan")
  end

  describe "new plan creation" do
    before do
      visit_new_plan_page(@classroom)
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

    it "persists the plan to the db" do
      click_on_create_plan
      expect(page).to have_content("Plan was successfully created.")
      expect(page).to have_content(Plan.last.name)
    end

    context "with an inactive student" do
      before do
        @inactive_student = FactoryGirl.create(:student,
          classroom: @classroom,
          first_name: "Joe",
          last_name: "Lazy",
          inactive: true
        )
      end

      it "does not assign to the inactive student" do
        visit_new_plan_page(@classroom)
        expect(page).to have_no_selector("[data-student-id='#{@inactive_student.id}']")
      end
    end

    context "for already existing plan" do
      xit "assigns a different plan" do
        create_plan
        visit("/classrooms/#{@classroom.id}/plans/new")
        within "[data-student-id='#{@student.id}']" do
          expect(page).to have_select("plan_assignments_attributes_0_book_bag_id",
                                      selected: @book_bag2.global_id)
        end

        within "[data-student-id='#{@student2.id}']" do
          expect(page).to have_select("plan_assignments_attributes_1_book_bag_id",
                                      selected: @book_bag.global_id)
        end

        click_on_create_plan
      end
    end

    context "for exhausted plans" do
      it "prompts you to add a book bag and does not create a plan" do
        2.times { create_plan }

        expect {
          create_plan
        }.to_not change{ Plan.count }
        expect(current_path).to eq "/classrooms/#{@classroom.id}"
        expect(page).to have_content("Unable to generate a new plan for this classroom.")
      end
    end
  end

  def visit_new_plan_page(classroom)
    visit("/classrooms/#{classroom.id}/plans/new")
  end

  def click_on_create_plan
    click_on "Create Plan"
  end

  def create_plan
    visit_new_plan_page(@classroom)
    click_on_create_plan
    expect(current_path).to eq "/classrooms/#{@classroom.id}"
  end

  def add_classroom(class_name)
    add_school("Joshua Tree Middle School")
    visit("/classrooms")
    click_on("New Classroom")
    fill_in("Name", with: class_name)
    select("Joshua Tree Middle School", from: "School")
    click_on("Create Classroom")
  end

  def add_school(name)
    visit("/schools")
    click_on("New School")
    fill_in("Name", with: name)
    click_on("Create School")
  end
end
