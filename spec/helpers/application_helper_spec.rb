require 'spec_helper'

describe ApplicationHelper do
  describe "full_title" do
    it "outputs the default title" do
      full_title.should == "Open Source Story"
    end

    it "should append the inserted title" do
      full_title('Test').should == "Open Source Story - Test"
    end

    it "should over ride and not display the base title" do
      full_title('Test', true).should == "Test"
    end

    it "should display the base title when empty" do
      full_title('').should == "Open Source Story"
    end
  end
end
