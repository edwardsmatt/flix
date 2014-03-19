require 'spec_helper'

describe "A movie" do
  it "has fans" do
    movie = Movie.new(movie_attributes)
    fan1 = User.new(user_attributes(email: "larry@example.com"))
    fan2 = User.new(user_attributes(email: "moe@example.com"))

    movie.favorites.new(user: fan1)
    movie.favorites.new(user: fan2)

    expect(movie.fans).to include(fan1)
    expect(movie.fans).to include(fan2)
  end

  it "has critics" do
    movie = Movie.new(movie_attributes)
    critic1 = User.new(user_attributes(email: "larry@example.com"))
    critic2 = User.new(user_attributes(email: "moe@example.com"))

    movie.reviews.new(user: critic1, stars: 3, comment: "I laughed, I cried, I spilled my popcorn!")
    movie.reviews.new(user: critic2, stars: 3, comment: "I laughed, I cried, I spilled my popcorn!")

    expect(movie.critics).to include(critic1)
    expect(movie.critics).to include(critic2)
  end

  it "requires a title" do
    movie = Movie.new(title: "")

    expect(movie.valid?).to be_false # populates errors
    expect(movie.errors[:title].any?).to be_true
  end

  it "requires a description" do
    movie = Movie.new(description: "")

    expect(movie.valid?).to be_false
    expect(movie.errors[:description].any?).to be_true
  end

  it "requires a released on date" do
    movie = Movie.new(released_on: "")

    expect(movie.valid?).to be_false
    expect(movie.errors[:released_on].any?).to be_true
  end

  it "requires a duration" do
    movie = Movie.new(duration: "")

    expect(movie.valid?).to be_false
    expect(movie.errors[:duration].any?).to be_true
  end

  it "requires a description over 24 characters" do
    movie = Movie.new(description: "X" * 24)

    expect(movie.valid?).to be_false
    expect(movie.errors[:description].any?).to be_true
  end

  it "accepts a $0 total gross" do
    movie = Movie.new(total_gross: 0.00)

    expect(movie.valid?).to be_false
    expect(movie.errors[:total_gross].any?).to be_false
  end

  it "accepts a positive total gross" do
    movie = Movie.new(total_gross: 10000000.00)

    expect(movie.valid?).to be_false
    expect(movie.errors[:total_gross].any?).to be_false
  end

  it "rejects a negative total gross" do
    movie = Movie.new(total_gross: -10000000.00)

    expect(movie.valid?).to be_false
    expect(movie.errors[:total_gross].any?).to be_true
  end

  # it "accepts properly formatted image file names" do
  #   file_names = %w[e.png movie.png movie.jpg movie.gif MOVIE.GIF]
  #   file_names.each do |file_name|
  #     movie = Movie.new(image_file_name: file_name)

  #     expect(movie.valid?).to be_false
  #     expect(movie.errors[:image_file_name].any?).to be_false
  #   end
  # end

  # it "rejects improperly formatted image file names" do
  #   file_names = %w[movie .jpg .png .gif movie.pdf movie.doc]
  #   file_names.each do |file_name|
  #     movie = Movie.new(image_file_name: file_name)

  #     expect(movie.valid?).to be_false
  #     expect(movie.errors[:image_file_name].any?).to be_true
  #   end
  # end

  it "accepts any rating that is in an approved list" do
    ratings = %w[G PG PG-13 R NC-17]
    ratings.each do |rating|
      movie = Movie.new(rating: rating)

      expect(movie.valid?).to be_false
      expect(movie.errors[:rating].any?).to be_false
    end
  end

  it "rejects any rating that is not in the approved list" do
    ratings = %w[R-13 R-16 R-18 R-21]
    ratings.each do |rating|
      movie = Movie.new(rating: rating)

      expect(movie.valid?).to be_false
      expect(movie.errors[:rating].any?).to be_true
    end
  end

  it "is valid with example attributes" do
    movie = Movie.new(movie_attributes)

    expect(movie.valid?).to be_true
  end

  it "is a flop if the total gross is less than $50M" do
    movie = Movie.new(total_gross: 40000000)

    expect(movie).to be_flop
  end

  it "is not a flop if the total gross is greater than $50M" do
    movie = Movie.new(total_gross: 60000000)

    expect(movie).not_to be_flop
  end

  it "has many reviews" do
    movie = Movie.new(movie_attributes)

    review1 = movie.reviews.new(review_attributes)
    review2 = movie.reviews.new(review_attributes)

    expect(movie.reviews).to include(review1)
    expect(movie.reviews).to include(review2)
  end

  it "deletes associated reviews" do
    movie = Movie.create!(movie_attributes)

    movie.reviews.create!(review_attributes)

    expect {
      movie.destroy
    }.to change(Review, :count).by(-1)
  end

  it "calculates the average number of review stars" do
    movie = Movie.create!(movie_attributes)

    movie.reviews.create!(review_attributes(stars: 1))
    movie.reviews.create!(review_attributes(stars: 3))
    movie.reviews.create!(review_attributes(stars: 5))

    expect(movie.average_stars).to eq(3)
  end

  context "released query" do
    it "returns the movies with a released on date in the past" do
      movie = Movie.create!(movie_attributes(released_on: 3.months.ago))

      expect(Movie.released).to include(movie)
    end

    it "does not return movies with a released on date in the future" do
      movie = Movie.create!(movie_attributes(released_on: 3.months.from_now))

      expect(Movie.released).not_to include(movie)
    end

    it "returns released movies ordered with the most recently-released movie first" do
      movie1 = Movie.create!(movie_attributes(released_on: 3.months.ago))
      movie2 = Movie.create!(movie_attributes(released_on: 2.months.ago))
      movie3 = Movie.create!(movie_attributes(released_on: 1.months.ago))

      expect(Movie.released).to eq([movie3, movie2, movie1])
    end
  end

  context "hits query" do
    it "returns movies with a total gross of at least 300_000_000" do
      movie1 = Movie.create!(movie_attributes(total_gross: 300_000_000))
      movie2 = Movie.create!(movie_attributes(total_gross: 9_000_000))

      expect(Movie.hits).to eq([movie1])
    end
  end

  context "flops query" do
    it "returns movies with a total gross less than 50_000_000" do
      movie1 = Movie.create!(movie_attributes(total_gross: 300_000_000))
      movie2 = Movie.create!(movie_attributes(total_gross: 49_000_000))

      expect(Movie.flops).to eq([movie2])
    end
  end

end