# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


puts 'Creating users...'
users = []
50.times do
  users << User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: 'password'
  )
end

# Topics
puts 'Creating topics...'
topics = []
100.times do
  topics << Topic.create!(
    user: users.sample,
    title: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.paragraph,
    published_at: Faker::Date.between(from: "2024-01-01", to: Date.today)
  )
end

# Answers
puts 'Creating answers...'
150.times do
  selected_topic = topics.sample

  Answer.create!(
    user: users.sample,
    topic: selected_topic,
    body: Faker::Lorem.paragraph(sentence_count: 2),
    reason: Faker::Lorem.sentence,
    published_at: Faker::Date.between(from: selected_topic.published_at, to: Date.today)
  )
end

# reactions
puts 'Creating reactions...'
Reaction.create!(
  name: "共感"
)
Reaction.create!(
  name: "納得"
)
Reaction.create!(
  name: "爆笑"
)

puts 'Seeding done!'
