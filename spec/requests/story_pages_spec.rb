require 'spec_helper'

describe "Story Pages" do
  subject { page }

  describe "authorization" do
    let(:user) { FactoryGirl.create(:user) }

    describe "for non-signed in users" do
      describe "visiting the create page" do
        before { visit new_story_path }
        it { should have_selector('title', text: full_title('Sign in')) }
      end

      describe "submitting to the post action" do
        before { post story_path }
        specify { response.should redirect_to(signin_path) }
      end

      let(:story) { FactoryGirl.create(:story) }
      describe "Story Snippets Pages" do

        describe "visiting the create page" do
          before { visit new_story_story_snippet_path(story) }
          it { should have_selector('title',  text: full_title('Sign in')) }
        end

        describe "submitting to the post action" do
          before { post story_story_snippet_path(story) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end

    describe "when attempting to visit a protected page" do

      describe "accessing new story" do
        before do
          visit new_story_path
          sign_in user
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: full_title('Create Story'))
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

      describe "accessing new story snippet" do
        let(:story) { FactoryGirl.create(:story) }

        before do
          visit new_story_story_snippet_path(story)
          sign_in user
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: full_title('Create Story Snippet'))
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
  end

  describe "View Story Page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:story) { FactoryGirl.create(:story, title: "Story 1") }
    let!(:s1) { FactoryGirl.create(:story_snippet, user: user, story: story) }

    before { visit story_path(story) }

    it { should have_selector("h1",     text: story.title) }
    it { should have_selector("title",  text: full_title(story.title, true)) }

    it { should have_content(story.description) }

    it { should_not have_link("Back") }
    it { should have_link("Next",     href: story_story_snippet_path(story, s1)) }

    describe "Reading Snippet 1" do
      let!(:s2) { FactoryGirl.create(:story_snippet, user: user, story: story) }
      before do
        click_link "Next"
      end

      it { should have_selector("h1",     text: story.title) }
      it { should have_selector("title",  text: full_title("#{story.title} - Chapter #{story.story_snippets.index { |item| item.id == s1.id } + 1 }", true))}
      it { should have_selector("h4", text: s1.content) }

      it { should have_link("Next",   href: story_story_snippet_path(story, s2)) }

      describe "Reading Snippet 2" do
        before do
          click_link "Next"
        end

        it { should have_selector("h1",     text: story.title) }
        it { should have_selector("title",  text: full_title("#{story.title} - Chapter #{story.story_snippets.index { |item| item.id == s2.id } + 1}", true))}
        it { should have_selector("h4",     text: s1.content) }

        it { should have_link("Back",   href: story_story_snippet_path(story, s1)) }
        it { should_not have_link("Next") }

        describe "Navigating back" do
          before do
            click_link "Back"
          end

          it { should have_content(story.title) }

          it { should have_selector("h1",     text: story.title) }
          it { should have_selector("title",  text: full_title(story.title, true)) }
          it { should have_selector("h4",     text: s1.content) }

          it { should_not have_link("Back") }
          it { should have_link("Next",     href: story_story_snippet_path(story, s2)) }
        end
      end
    end
  end

  describe "Create Story" do
    let(:user) { FactoryGirl.create(:user) }
    let(:submit) { "Create" }
    before do
      sign_in user
      visit new_story_path
    end

    it { should have_selector('title',      text: full_title("Create Story")) }
    it { should have_selector('h1',         text: 'Create Story') }

    it { should have_field('Title') }
    it { should have_field('Description') }

    it { should have_button(submit) }

    describe "with invalid information" do
      it "should not create a story" do
        expect { click_button submit }.not_to change(Story, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector("title",  text: full_title("Create Story")) }
        it { should have_selector(".help-inline", text: "can't be blank") }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Title", with: "New Story"
        fill_in "Description",with: "This is a test description"
        fill_in "Content", with: "Here is some content that make what we've put in valid.  Thank god we have some valid information"
      end

      it "should create a story" do
        expect { click_button submit }.to change(Story, :count)
      end

      it "should create a story snippet" do
        expect { click_button submit }.to change(StorySnippet, :count)
      end

      describe "after submission" do
        before { click_button submit }
        let(:story) { Story.find_by_title('New Story') }

        describe "create story snippet" do
          before { visit new_story_story_snippet_path story }
          let(:submit) { "Create" }

          it { should have_selector('title',    text: full_title('Create Story Snippet')) }
          it { should have_selector('h1',       text: 'Create Story Snippet') }

          it { should have_field('Content') }

          describe "with invalid information" do
            it "should not add a Story Snippet" do
              expect { click_button submit }.to_not change(StorySnippet, :count)
            end
          end

          describe "with valid information" do
            before do
              fill_in "Content", with: "here is some test content lets make sure that it's long enough and that we can save it without issue here we go oh lord look how long this is"
            end

            it "should create a story snippet on the right story" do
              expect { click_button submit }.to change(story.story_snippets, :count).by(1)
            end

            describe "after submission" do
              before { click_button submit }
              let(:snippet) { StorySnippet.last }

              it { should have_selector("h1",     text: story.title) }
              it { should have_selector("title",  text: full_title("#{story.title} - Chapter #{story.story_snippets.index { |item| item.id == snippet.id } + 1}", true))}
              it { should have_content("here is some test content lets make sure that it's long enough and that we can save it without issue here we go oh lord look how long this is") }
            end
          end
        end
      end
    end
  end
end
