class StoriesController < ApplicationController
  before_filter :signed_in_user,  only: [:new, :create]

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(params[:story])
    if @story.save
      redirect_to new_story_story_snippet_path @story
    else
      render 'new'
    end
  end

  def show
    @story = Story.find(params[:id])
    @next_snippet = @story.story_snippets.first
    @previous_snippet = nil
  end

  def index
    @stories = Story.paginate(page: params[:page])
  end
end
