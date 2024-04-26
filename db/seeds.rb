# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"
puts "Deleting all users..."
puts "Deleting all posts..."
puts "Deleting all comments..."



puts "Creating users..."

User.create!(email: "pedro@gmail.com", password: "123456", name: Faker::Creature::Dog.name)
User.create!(email: "pedro2@gmail.com", password: "123456", name: Faker::Creature::Dog.name)
User.create!(email: "pedro3@gmail.com", password: "123456", name: Faker::Creature::Dog.name)
User.create!(email: "pedro4@gmail.com", password: "123456", name: Faker::Creature::Dog.name)
User.create!(email: "pedro5@gmail.com", password: "123456", name: Faker::Creature::Dog.name)
User.create!(email: "pedro6@gmail.com", password: "123456", name: Faker::Creature::Dog.name)
User.create!(email: "pedro7@gmail.com", password: "123456", name: Faker::Creature::Dog.name)

puts "Creating 100 posts..."
100.times do
  Post.create!(
    title: Faker::Lorem.sentence(word_count: 3),
    content: Faker::Lorem.sentence(word_count: 50),
    user_id: rand(1..7)
  )
end

100.times do
  Tag.create!(
    tag_name: Faker::Lorem.sentence(word_count: 1),
    post_id: rand(1..100)
  )
end

puts "Creating 500 comments..."

500.times do
  Comment.create!(
    post_id: rand(1..100),
    content: Faker::Lorem.sentence(word_count: 50),
    user_id: rand(0..7)
  )
end
