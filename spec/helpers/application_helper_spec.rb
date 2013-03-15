require 'spec_helper'

describe ApplicationHelper do
  describe "full_title" do
    it "outputs the default title" do
      full_title.should == "Crowd Source Story"
    end

    it "should append the inserted title" do
      full_title('Test').should == "Crowd Source Story - Test"
    end

    it "should over ride and not display the base title" do
      full_title('Test', true).should == "Test"
    end

    it "should display the base title when empty" do
      full_title('').should == "Crowd Source Story"
    end
  end
end
