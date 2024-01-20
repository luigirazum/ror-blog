# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
# Generate users
(10..20).to_a.sample.times do
  if (1..50).to_a.sample < 30
    name = Faker::Name.female_first_name
  else
    name = Faker::Name.male_first_name
  end

  uname = "#{name} #{Faker::Name.last_name}"
  photo_url = "https://fakeimg.pl/160x160/252f3f,255/f29800,255/?font=roboto&text=#{name}+📸"
  user_bio = []
  3.times do
    user_bio << Faker::Lorem.paragraphs(number: 3).join(' ')
  end

  User.create(name: uname, photo: photo_url, bio: user_bio.join('\\n'))
end

# Generate Posts
User.all.each do |user|
  next if (1..50).to_a.sample < 20

  (2..7).to_a.sample.times do
    user.posts.create(
      title: Faker::Lorem.sentence(word_count: 18),
      text: Faker::Lorem.paragraph(sentence_count: 52)
      )
  end

  # Generate comments to user's posts
  user.posts.each do |post|
    next if (1..100).to_a.sample < 35

    users = User.all
    (1..User.count).to_a.sample.times do

      post.comments.create(
        user: users.sample,
        text: Faker::Lorem.paragraph(sentence_count: 5)
      )
    end
  end
  
  # Generate likes to user's posts
  user.posts.each do |post|
    next if (1..100).to_a.sample < 55

    users = User.all
    liked_by = []
    (1..User.count).to_a.sample.times do
      current_user = users.sample
      next if liked_by.include? current_user.id

      post.likes.create(user: current_user)
      liked_by << current_user.id
    end
  end
end
