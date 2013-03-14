class User < ActiveRecord::Base
  attr_accessible :email, :name, :username, :password, :password_confirmation
  has_secure_password

  has_many    :story_snippets, order: "created_at DESC"
  has_many    :stories, through: :story_snippets
  has_many    :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many    :followed_users, through: :relationships, source: :followed
  has_many    :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many    :followers, through: :reverse_relationships, source: :follower

  before_save { email.downcase! }
  before_save { create_token "remember" }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,        presence: true, length: { minimum: 3, maximum: 100 }
  validates :email,       presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  validates :username,    presence: true
  validates :password,    presence: true, length: { minimum: 6 }
  validates :password_confirmation,   presence: true

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def feed
    StorySnippet.from_users_followed_by(self)
  end

  private
    def create_token(attr)
      self[attr] = SecureRandom.urlsafe_base64
    end
end
