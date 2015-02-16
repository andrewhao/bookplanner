require "spec_helper"

feature "Managing book bags", type: :feature do
  before do
    @classroom = FactoryGirl.create(:classroom)
    FactoryGirl.create_list(:student, 10, classroom: @classroom)
    FactoryGirl.create_list(:book_bag, 10, classroom: @classroom)
  end

  subject { BookBag.last }

  scenario "renaming book bag global IDs" do
    new_id = "987"
    visit edit_book_bag_path(subject)
    expect(page).to have_field("Internal ID", with: subject.global_id)
    fill_in("Internal ID", with: new_id)
    click_on("Update Book bag")
    expect(current_path).to eq classroom_path(@classroom)
    expect(page).to have_text "Book bag #{new_id} was successfully updated."
  end

  scenario "making book bag inactive" do
    create_plan(@classroom)
    visit(classroom_path(@classroom))
    click_on_edit_book_bag_link(subject)
    expect(page).to have_checked_field("Active?")
    uncheck("Active?")
    click_on("Update Book bag")
  end
end
