# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string(255)      not null
#  password_digest        :string(255)      not null
#  password_reset_sent_at :datetime
#  password_reset_token   :string(255)
#  plan                   :integer          default(0), not null
#  refresh_token          :string(255)
#  role                   :integer          default(0), not null
#  username               :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
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
