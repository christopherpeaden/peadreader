FactoryGirl.define do
  factory :feed do
    title { Faker::Name.title }
    url { Faker::Internet.url }
    last_modified { "" }
    etag { "" }
    user
  end
end
