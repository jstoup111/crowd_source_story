require 'spec_helper'

describe StorySnippet do
  let(:user) { FactoryGirl.create(:user) }
  let(:story){ FactoryGirl.create(:story) }
  before do
    @snippet = story.story_snippets.build(content: "Some new content that must be long enough to not throw an error")
    @snippet.user = user
  end

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
    before { @snippet.content = "a" * 24 }
    it { should_not be_valid }
  end

  describe "when content is too long" do
    before { @snippet.content = "a" * 10001 }
    it { should_not be_valid }
  end

  describe "story association" do
    before { @snippet.save }

    it "should not destroy associated stories" do
      @snippet.destroy
      Story.find_by_id(@snippet.story.id).should_not be_nil
    end
  end

  describe "user association" do
    before { @snippet.save }

    it "should not destroy associated users" do
      @snippet.destroy
      User.find_by_id(@snippet.user.id).should_not be_nil
    end
  end
end
