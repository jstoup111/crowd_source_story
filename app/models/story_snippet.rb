class StorySnippet < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user
  belongs_to :story

  validates :content,   presence: true, length: { maximum: 1000, minimum: 25 }
  validates :user_id,   presence: true
  validates :story_id,  presence: true
end
