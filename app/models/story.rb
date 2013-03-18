class Story < ActiveRecord::Base
  attr_accessible :description, :title, :story_snippets_attributes

  has_many    :story_snippets, dependent: :destroy, inverse_of: :story
  has_many    :users, through: :story_snippets

  accepts_nested_attributes_for :story_snippets

  validates :title,       presence: true, length: { maximum: 150, minimum: 3 }, uniqueness: true
  validates :description ,presence: true

  default_scope order: 'stories.created_at DESC'
end
