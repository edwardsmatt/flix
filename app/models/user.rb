class User < ActiveRecord::Base
  before_save :format_username, :format_email

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie
  scope :by_name, -> { order(name: :asc)}
  scope :not_admins, -> { by_name.where(admin: false)}

  has_secure_password

  validates :name, presence: true

  validates :email, presence: true,
  format: /\A\S+@\S+\z/,
  uniqueness: { case_sensitive: false }

  validates :username, presence: true,
  format: /\A[A-Z0-9]+\z/i,
  uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 10, allow_blank: true }


  def self.authenticate(email_or_username, password)
    user = User.find_by(email: email_or_username) || User.find_by(username: email_or_username)
    user && user.authenticate(password)
  end

  def format_username
    self.username = username.downcase
  end

  def format_email
    self.email = email.downcase
  end

  def to_param
    username
  end

end
