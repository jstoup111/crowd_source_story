class User < ActiveRecord::Base
  attr_accessible :confirmation, :email, :name, :password, :password_confirmation
  has_secure_password

  has_many    :story_snippets
  has_many    :stories, through: :story_snippets

  before_save { email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,        presence: true, length: { minimum: 3, maximum: 100 }
  validates :email,       presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  validates :password,    presence: true, length: { minimum: 6 }
  validates :password_confirmation,   presence: true
end
