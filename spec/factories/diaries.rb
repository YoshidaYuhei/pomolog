# == Schema Information
#
# Table name: diaries
#
#  id         :bigint           not null, primary key
#  content    :string(255)      not null
#  ended_at   :datetime         not null
#  started_at :datetime         not null
#  title      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_diaries_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :diary do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    started_at { Time.current }
    ended_at { Time.current + 1.hour }
    user { association(:user) }
  end
end
