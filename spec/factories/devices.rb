# == Schema Information
#
# Table name: devices
#
#  id         :bigint           not null, primary key
#  key        :string(255)      not null
#  name       :string(255)
#  os_type    :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_devices_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :device do
    key { 'test_key' }
    os_type { 'ios' }
    name { 'test_name' }
    user do
      association(
        :user,
        strategy: :build,
        devices: [ instance ]
      )
    end
  end
end
