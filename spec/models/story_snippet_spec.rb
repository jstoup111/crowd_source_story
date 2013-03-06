require 'spec_helper'

describe StorySnippet do
  let(:user) { FactoryGirl.create(:user) }
  let(:story){ FactoryGirl.create(:story) }
  before { @snippet = story.story_snippets.build(content: "Some new content") }

  subject { @snippet }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:story_id) }
  its(:user) { should == user }
  its(:story){ should == story }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        StorySnippet.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to story_id" do
      expect do
        StorySnippet.new(story_id: story.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when user_id is not present" do
    before { @snippet.user_id = nil }
    it { should_not be_valid }
  end

  describe "when story_id is not present" do
    before { @snippet.story_id = nil }
    it { should_not be_valid }
  end

  describe "when content is not supplied" do
    before { @snippet.content = " " }
    it { should_not be_valid }
  end

  describe "when content is too short" do
    before { @snippet.content = "a" * 99 }
    it { should_not be_valid }
  end

  describe "when content is too long" do
    before { @snippet.content = "a" * 1001 }
    it { should_not be_valid }
  end

  describe "story association" do
    before { @user.save }
    let!(:older_story) do
      FactoryGirl.create(:story, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_story) do
      FactoryGirl.create(:story, user: @user, created_at: 1.minute.ago)
    end

    it "should have the right stories in the right order" do
      @user.stories.should == [newer_story, older_story]
    end

    it "should not destroy associated stories" do
      stories = @user.stories.dup
      @user.destroy
      stories.should_not be_empty
      stories.each do |s|
        Story.find_by_id(s.id).should_not be_nil
      end
    end
  end
=begin
# TODO user and story association
  describe "user association" do
    before { @user.save }
    let!(:older_story) do
      FactoryGirl.create(:story, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_story) do
      FactoryGirl.create(:story, user: @user, created_at: 1.minute.ago)
    end

    it "should have the right stories in the right order" do
      @user.stories.should == [newer_story, older_story]
    end

    it "should not destroy associated stories" do
      stories = @user.stories.dup
      @user.destroy
      stories.should_not be_empty
      stories.each do |s|
        Story.find_by_id(s.id).should_not be_nil
      end
    end
  end
=end
end
