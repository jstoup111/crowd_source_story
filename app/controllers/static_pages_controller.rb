class StaticPagesController < ApplicationController
  def home
    @user = current_user
    if @user
      @story_snippets = @user.story_snippets.first(5)
    else
      @story_snippets = nil
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def terms
  end

  def privacy
  end
end
