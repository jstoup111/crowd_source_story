require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "authorization" do
    let(:user) { FactoryGirl.create(:user) }
    describe "for non-signed in users" do
      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: full_title('Sign in')) }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should_not have_selector('title', text: full_title('Sign in')) }
        end

        # TODO followers
      end
    end

    describe "when attempting to visit a protected page" do
      before do
        visit edit_user_path(user)
        sign_in user
      end

      describe "after signing in" do
        it "should render the desired protected page" do
          page.should have_selector('title', text: full_title('Edit your profile'))
        end

        describe "when signing in again" do
          before do
            log_out
            visit signin_path
            sign_in user
          end

          it "should render the default (profile) page" do
            page.should have_selector('title',  text: full_title(""))
          end
        end
      end
    end
  end

  describe "Signup page" do
    before { visit signup_path }

    it { should have_selector("title",      text: "Sign up") }
    it { should have_selector("h1",         text: "Sign up") }

    let(:submit) { "Become a writer" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector("title",  text: full_title("Sign up")) }
        it { should have_selector(".help-inline", text: "can't be blank") }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "New User"
        fill_in "Email",with: "user@example.com"
        fill_in "Username",with: "new_user1"
        fill_in "Password",with: "foobar"
        fill_in "Password Confirmation",with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector("title",  text: full_title(user.name, true)) }
        it { should have_selector("div.alert.alert-success",  text: "Welcome") }
        it { should have_link('Sign out') }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:story1) { FactoryGirl.create(:story, title: "Story 1") }
    let!(:story2) { FactoryGirl.create(:story, title: "Story 2") }
    let!(:s1) { FactoryGirl.create(:story_snippet, user: user, story: story1) }
    let!(:s2) { FactoryGirl.create(:story_snippet, user: user, story: story2) }

    before { visit user_path(user) }

    it { should have_selector("h1",     text: user.name) }
    it { should have_selector("title",  text: user.name) }

    describe "stories" do
      it { should have_content(story1.title) }
      it { should have_content(story2.title) }
      it { should have_content(user.stories.count) }
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector("input", value: "Follow") }
        end
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',     text: 'Edit your profile') }
      it { should have_selector('title',  text: full_title('Edit your profile')) }
      it { should have_link('change',   href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Change" }

      it { should have_selector('.help-inline',  text: "can't be blank") }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Password", with: user.password
        fill_in "Password Confirmation", with: user.password
        click_button "Change"
      end

      it { should have_selector('title', text: full_title("")) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should == new_name }
    end
  end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('title',  text: full_title('Writers')) }
    it { should have_selector('h1',     text: 'Writers') }

    describe "pagination" do
      before(:all)  { 30.times { FactoryGirl.create(:user) } }
      after(:all)   { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }

    end
  end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_selector('title',  text: full_title("#{user.name} - Following", true)) }
      it { should have_selector('h3',     text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_selector('title',  text: full_title("#{other_user.name} - Followers", true)) }
      it { should have_selector('h3',     text: 'Followers') }
      it { should have_link(user.name,    href: user_path(user)) }
    end
  end

  describe "Stories" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:story1) { FactoryGirl.create(:story, title: full_title("Story 1", true)) }
    let!(:s1) { FactoryGirl.create(:story_snippet, user: user, story: story1) }

    before do
      sign_in user
      visit stories_user_path(user)
    end

    it { should have_selector('title',  text: full_title("#{user.name} - Stories", true)) }
    it { should have_selector('h3',     text: "#{user.name} - Stories") }
    it { should have_link(story1.title, href: story_path(story1)) }
  end
end