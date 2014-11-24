require "spec_helper"

feature "Managing classrooms" do
  before do
    @classroom = FactoryGirl.create(:classroom)
    FactoryGirl.create_list(:student, 10, classroom: @classroom)
    FactoryGirl.create_list(:book_bag, 10, classroom: @classroom)
  end

  scenario "viewing book bags per classroom" do
    visit("/classrooms/#{@classroom.id}")
    expect(page).to have_text("Book bags (10)")
  end

  scenario "viewing students  per classroom" do
    visit("/classrooms/#{@classroom.id}")
    expect(page).to have_text("Students (10)")
  end
end
