class StorySnippet < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user
  belongs_to :story

  validates :content,   presence: true, length: { maximum: 1000, minimum: 100 }
end
