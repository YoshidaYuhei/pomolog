# == Schema Information
#
# Table name: user_profiles
#
#  id         :bigint           not null, primary key
#  age        :integer          not null
#  gender     :integer          not null
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe UserProfile, type: :model do
  describe 'associations' do
    let(:model) { build(:user_profile) }

    it do
      expect(model).to(
        belong_to(:user)
        .optional(true)
        .inverse_of(:user_profile)
      )
    end
  end
end
