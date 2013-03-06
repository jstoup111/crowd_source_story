require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example user", email: "user@example.com", password:"foobar", password_confirmation:"foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:confirmation) }
  it { should respond_to(:stories) }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to password_digest" do
      expect do
        User.new(password_digest: @user.password_digest)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 101 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baaz.com foo@bar+baz.com]
      addresses.each do |address|
        @user.email = address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |address|
        @user.email = address
        @user.should be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email. email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 2 }
    it { should be_invalid }
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
