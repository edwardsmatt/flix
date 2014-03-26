require 'spec_helper'

describe "Editing a genre" do
  before do
    admin = User.create!(user_attributes(admin: true))
    sign_in(admin)
  end

  it "updates the Genre's details and then displays the update" do
    genre = Genre.create!(name: 'Action')

    visit genre_url(genre)

    click_link 'Edit'

    expect(current_path).to eq(edit_genre_path(genre))
    fill_in 'Name', with: "Updated Name"

    click_button 'Update Genre'

    expect(current_path).to eq(genre_path(genre.reload))
    expect(page).to have_text("Updated Name")
  end

  it "does not allow invalid data" do
    genre = Genre.create!(name: 'Action')

    visit edit_genre_path(genre)

    fill_in 'Name', with: ""

    click_button 'Update Genre'

    expect(page).to have_text("error")
  end
end
