require 'spec_helper'

describe Story do
  before { @story = Story.new(title: "New Story", description: "A tale of a new story between some random people.") }
  let(:user) { FactoryGirl.create(:user) }
  let(:story_snippet)   { FactoryGirl.create(:story_snippet, user: user, story: story) }

  subject { @story }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:story_snippets) }

  it { should be_valid }

  describe "when title is not supplied" do
    before { @story.title = " " }
    it { should_not be_valid }
  end

  describe "when description is not supplied" do
    before { @story.description = " " }
    it { should_not be_valid }
  end

  describe "story snippet association" do
    before { @story.save }
    let!(:older_snippet) do
      FactoryGirl.create(:story_snippet, user: user, story: @story, created_at: 1.day.ago)
    end
    let!(:newer_snippet) do
      FactoryGirl.create(:story_snippet, user: user, story: @story, created_at: 1.minute.ago)
    end

    it "should have the right snippets in the right order" do
      @story.story_snippets.should == [older_snippet, newer_snippet]
    end

    it "should destroy associated story snippets" do
      snippets = @story.story_snippets.dup
      @story.destroy
      snippets.should_not be_empty
      snippets.each do |s|
        StorySnippet.find_by_id(s.id).should be_nil
      end
    end

    it "should not destroy associated users" do
      users = @story.users.dup
      users.should_not be_empty
      @story.destroy
      users.should_not be_empty
      users.each do |s|
        User.find_by_id(s.id).should_not be_nil
      end
    end
  end
end
