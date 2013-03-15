class StorySnippetsController < ApplicationController
  before_filter :signed_in_user,  only: [:new, :create]

  def show
    @story = Story.find(params[:story_id])
    @story_snippet = StorySnippet.find(params[:id])
    @next_snippet = StorySnippet.same_story(params[:story_id]).previous(params[:id]).first
    @previous_snippet = StorySnippet.same_story(params[:story_id]).next(params[:id]).first
  end

  def new
    @story = Story.find(params[:story_id])
    @content = @story.story_snippets.last ? @story.story_snippets.last.content : ""
    @story_snippet = @story.story_snippets.build
  end

  def create
    @story = Story.find(params[:story_id])
    @story_snippet = @story.story_snippets.build(params[:story_snippet])
    @story_snippet.user = current_user
    if @story_snippet.save
      redirect_to story_story_snippet_path @story, @story_snippet
    else
      render 'new'
    end
  end
end
