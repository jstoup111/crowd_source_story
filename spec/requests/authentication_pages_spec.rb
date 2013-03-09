require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',     text: 'Sign in') }
    it { should have_selector('title',  text: 'Sign in') }

    describe "with invalid information" do
      before { click_button "Sign in" }
      let(:user) { FactoryGirl.create(:user, email: "123@gmail.com") }

      it { should have_selector('h1',   text: 'Sign in') }
      it { should have_error_message('Invalid') }

      it { should_not have_link('Profile',    href: user_path(user)) }
      it { should_not have_link('Settings',   href: edit_user_path(user)) }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('title',    text: user.name) }

      it { should have_link('Stories',      href: stories_path) }
      it { should have_link('Users',        href: users_path) }
      it { should have_link('Profile',      href: user_path(user)) }
      it { should have_link('Settings',     href: edit_user_path(user)) }
      it { should have_link('Sign out',     href: signout_path) }

      it { should_not have_link('Sign in',  href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title',  text: 'Edit user') }
      end
    end

    describe "for non-signed-in users" do
      describe "in the Stories controller" do

      end

      describe "in the Story Snippets controller" do

      end
    end
  end
end