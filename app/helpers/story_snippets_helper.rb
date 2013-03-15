module StorySnippetsHelper

  def get_chapter(story, story_snippet)
    "Chapter #{story.story_snippets.index { |item| item.id == story_snippet.id } + 1}"
  end
end
