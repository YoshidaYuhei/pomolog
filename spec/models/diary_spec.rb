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
require 'rails_helper'

RSpec.describe Diary, type: :model do
  describe 'associations' do
    let(:model) { build(:diary) }

    it do
      expect(model).to(
        belong_to(:user)
        .inverse_of(:diaries)
      )
    end
  end

  describe 'validations' do
    let(:model) { build(:diary) }

    it do
      expect(model).to validate_presence_of(:title)
      expect(model).to validate_presence_of(:content)
      expect(model).to validate_presence_of(:started_at)
      expect(model).to validate_presence_of(:ended_at)
      expect(model).to validate_length_of(:title).is_at_most(255)
      expect(model).to validate_length_of(:content).is_at_most(65535)
    end
  end
end
