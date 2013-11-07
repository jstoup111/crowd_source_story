namespace :db do
  desc "Fill Database with sample data"
  task populate: :environment do
    make_users
    make_stories
    make_story_snippets
    #make_relationships
  end
end

def make_users
  admin = User.create!(name: "Example User",
                       username: "example",
                       email: "example@opensourcestory.org",
                       password: "foobar",
                       password_confirmation: "foobar")
  99.times do |n|
    name = Faker::Name.name
    username = "example#{n+1}"
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(name: name,
                 username: username,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_stories
  99.times do |n|
    title = Faker::Name.name
    description = "test description for the #{title} story.  Just some more information"
    Story.create!(title: title,
                  description: description)
  end
end

def make_story_snippets
  users = User.all(limit: 6)
  stories = Story.all(limit: 6)
  5.times do
    content = Faker::Lorem.sentence(10)
    users.each do |user|
      stories.each do |story|
        snippet = user.story_snippets.build(content: content)
        snippet.story = story
        snippet.save
      end
    end
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end
