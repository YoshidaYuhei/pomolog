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
