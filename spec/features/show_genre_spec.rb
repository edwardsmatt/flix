require 'spec_helper'

describe "Viewing an individual genre" do
   before do
    @genre = Genre.create!(name: 'Action')
    @user = User.create!(user_attributes(admin: true))

    sign_in(@user)
  end

  it "shows the genre" do
    visit genre_url(@genre)
    expect(page).to have_text(@genre.name)
  end

  it "shows the movies in that genre" do
    @movie = Movie.create!(movie_attributes)
    @movie.genres << @genre
    visit genre_url(@genre)
    expect(page).to have_text(@movie.title)
  end

  it "shows the message if there are no movies in the genre" do
    @movie = Movie.create!(movie_attributes)
    visit genre_url(@genre)
    expect(page).to have_text("no movies")
  end
end