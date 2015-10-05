FactoryGirl.define do
  factory :item do
    title { Faker::Name.title }
    url   { Faker::Internet.url }
    published { Time.now }
    feed
  end
  
end
