FactoryBot.define do
  factory :user_profile do
    name { 'test_name' }
    gender { 0 }
    age { 20 }
    user do
      association(
        :user,
        strategy: :build,
        user_profile: instance
      )
    end
  end
end
