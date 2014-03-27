require 'spec_helper'

describe "Creating a new genre" do
  before do
    admin = User.create!(user_attributes(admin: true))
    sign_in(admin)
  end
  it "saves the genre and shows the new genre's details" do
    visit genres_url

    click_link 'Add New Genre'

    expect(current_path).to eq(new_genre_path)

    fill_in "Name", with: "New Genre"
    click_button 'Create Genre'

    expect(current_path).to eq(genre_path(Genre.last))
    expect(page).to have_text('New Genre')
    expect(page).to have_text('Genre successfully created!')
  end

  it "does not save the movie if it's invalid" do
    visit new_genre_url

    expect {
      click_button 'Create Genre'
      }.not_to change(Genre, :count)

      expect(page).to have_text('error')
    end
  end
