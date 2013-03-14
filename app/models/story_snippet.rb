class StorySnippet < ActiveRecord::Base
  scope :same_story,    lambda { |att| { conditions: ["story_id = ?",att] } }
  scope :next,          lambda { |att| { conditions: ["id <?",att] } }
  scope :previous,      lambda { |att| { conditions: ["id >?",att] } }

  attr_accessible :content

  belongs_to :user
  belongs_to :story

  validates :content,   presence: true, length: { maximum: 10000, minimum: 25 }
  validates :user_id,   presence: true
  validates :story_id,  presence: true

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user)
  end
end
