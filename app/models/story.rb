class Story < ActiveRecord::Base
  attr_accessible :description, :title

  has_many    :story_snippets, dependent: :destroy
  has_many    :users, through: :story_snippets

  validates :title,       presence: true, length: { maximum: 150, minimum: 3 }
  validates :description ,presence: true

  default_scope order: 'stories.created_at DESC'
end
