class StoriesController < ApplicationController
  before_filter :signed_in_user,  only: [:new, :create]

  def new
    @story = Story.new
    @story.story_snippets.build
    @story.story_snippets.first.user = current_user
  end

  def create
    @story = Story.new(params[:story])
    @story.story_snippets.first.user = current_user
    if @story.save
      #Mail users who are following
      
      redirect_to story_path @story
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
