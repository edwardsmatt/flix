require "spec_helper"

describe "Viewing the list of genres" do
 before do
  @user = User.create!(user_attributes(admin: false))
end

it "shows the genres" do
  genre_names = ["Comedy", "Drama", "Romance", 'Thriller', 'Fantasy', 'Documentary', 'Adventure', 'Animation', 'Sci-Fi']

  genre_names.each {|genre_name| Genre.create!(name: genre_name)}

  visit genres_url

  genre_names.each do |genre_name|
    expect(page).to have_text(genre_name)
  end
end
end