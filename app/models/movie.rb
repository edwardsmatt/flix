class Movie < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  has_attached_file :image, styles: {
    small: "90x133>",
    thumb: "50x50>"
  }

  validates :title, presence: true

  validates :released_on, :duration, presence: true

  validates :description, length: { minimum: 25 }

  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }

  validates_attachment :image,
  :content_type => { :content_type => ['image/jpeg', 'image/png'] },
  :size => { :less_than => 1.megabyte }

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :rating, inclusion: { in: RATINGS }

  def self.released
    where("released_on <= ?", Time.now).order(released_on: :desc)
  end

  def self.hits
    where('total_gross >= 300000000').order(total_gross: :desc)
  end

  def self.flops
    where('total_gross < 50000000').order(total_gross: :asc)
  end

  def flop?
    total_gross.blank? || total_gross < 50000000
  end

  def average_stars
    reviews.average(:stars)
  end
end
