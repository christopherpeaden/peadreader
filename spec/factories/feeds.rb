FactoryGirl.define do
  factory :feed do

    title Faker::Name.title
    url Faker::Internet.url
  end

end
