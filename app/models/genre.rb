class Genre < ActiveRecord::Base
  before_validation :generate_slug
  before_save :format_slug
  has_many :characterizations, dependent: :destroy
  has_many :movies, through: :characterizations
  validates :name, presence: true, uniqueness: true
  validates :slug, uniqueness: true


  def to_param
    slug
  end

  private
  def generate_slug
    self.slug ||= name.parameterize if name
  end

  def format_slug
    self.slug = slug.parameterize
  end
end
