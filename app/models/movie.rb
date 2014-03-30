class Movie < ActiveRecord::Base
  before_validation :generate_slug
  before_save :format_slug

  has_many :reviews, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  scope :released, -> { where("released_on <= ?", Time.now).order(released_on: :desc) }
  scope :hits, -> { released.where('total_gross >= 300000000').order(total_gross: :desc) }
  scope :flops, -> { released.where('total_gross < 50000000').order(total_gross: :asc) }
  scope :upcoming, -> { where("released_on > ?", Time.now).order(released_on: :asc) }
  scope :rated, ->(rating) { released.where(rating: rating)}
  scope :recent, ->(max=5) { released.limit(max) }
  scope :grossed_less_than, ->(amount) { released.where('total_gross < ?', amount) }
  scope :grossed_greater_than, ->(amount) { released.where('total_gross > ?', amount) }

  has_attached_file :image, styles: {
    small: "90x133>",
    thumb: "50x50>"
  }

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :title, presence: true, uniqueness: true
  validates :slug, uniqueness: true
  validates :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :rating, inclusion: { in: RATINGS }
  validates_attachment :image,
  :content_type => { :content_type => ['image/jpeg', 'image/png'] },
  :size => { :less_than => 1.megabyte }

  def flop?
    total_gross.blank? || total_gross < 50000000
  end

  def average_stars
    reviews.average(:stars)
  end

  def to_param
    slug
  end

  private
  def generate_slug
    self.slug ||= title.parameterize if title
  end

  def format_slug
    self.slug = slug.parameterize
  end
end
