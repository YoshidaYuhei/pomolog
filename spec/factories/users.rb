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
  factory :user do
    username { 'test_user' }
    email { Faker::Internet.email }
    password { 'password' }
    role { 0 }
    plan { 0 }
    devices do
      Array.new(2) do
        association(
          :device,
          strategy: :build,
          user: instance
        )
      end
    end

    trait :with_refresh_token do
      refresh_token { JwtService.encode({ user_id: id, exp: 14.days.from_now.to_i }) }
    end

    trait :with_password_reset_token do
      password_reset_token { SecureRandom.urlsafe_base64 }
      password_reset_sent_at { Time.current }
    end

    trait :with_user_profile do
      user_profile do
        association(
          :user_profile,
          strategy: :build,
          user: instance
        )
      end
    end
  end
end
