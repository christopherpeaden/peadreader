FactoryGirl.define do
  factory :item do
    title { Faker::Name.title }
    url   { Faker::Internet.url }
    published_at { Time.now }
    feed
    user
  end
  
end
