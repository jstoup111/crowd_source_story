class User < ActiveRecord::Base
  attr_accessible :email, :name, :username, :password, :password_confirmation
  has_secure_password

  has_many    :story_snippets, order: "created_at DESC"
  has_many    :stories, through: :story_snippets

  before_save { email.downcase! }
  before_save { create_token "remember" }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,        presence: true, length: { minimum: 3, maximum: 100 }
  validates :email,       presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  validates :username,    presence: true
  validates :password,    presence: true, length: { minimum: 6 }
  validates :password_confirmation,   presence: true

  private
    def create_token(attr)
      self[attr] = SecureRandom.urlsafe_base64
    end
end
