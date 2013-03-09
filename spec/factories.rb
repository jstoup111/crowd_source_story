FactoryGirl.define do
  factory :user do
    sequence(:name)         { |n| "Person #{n}" }
    sequence(:email)        { |n| "person_#{n}@example.com" }
    sequence(:username)     { |n| "person#{n}" }
    password                "foobar"
    password_confirmation   "foobar"
  end

  factory :story do
    title                   "Title"
    description             "Description of the story"
  end

  factory :story_snippet do
    content                 "A lot of content to make a story.  This is about a bunch of little blah blah blah foo foo foo"
    user
    story
  end
end