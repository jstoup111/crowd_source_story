require 'spec_helper'

describe Story do
  before { @story = Story.new(title: "New Story", description: "A tale of a new story between some random people.") }

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

=begin
# TODO story snippet association
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
=end
end
