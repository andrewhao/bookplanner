require "spec_helper"

describe "plan creation", type: :feature do
  before do
    @classroom = FactoryGirl.create(:classroom, name: "Mrs. Wu")
  end

  it "can be kicked off from a classroom page" do
    visit("/classrooms")
    click_on("Show")
    expect(page).to have_content("Classroom: Mrs. Wu")
    expect(page).to have_content("Create Plan")
    click_on("Create Plan")
    expect(page).to have_content("New plan")
  end

  describe "new plan creation" do
    it "lists potential assignments for a classroom" do
      visit("/classrooms/#{@classroom.id}/plans/new")
    end
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
