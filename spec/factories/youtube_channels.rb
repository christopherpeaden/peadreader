FactoryGirl.define do
  factory :youtube_channel do
    title { Faker::Name.title } 
    url { Faker::Internet.url }
    channel_id "UCpw2gh99XM6Mwsbksv0feEg"
    video_count 5
  end
end
