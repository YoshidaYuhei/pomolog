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
class Diary < ApplicationRecord
  belongs_to :user, inverse_of: :diaries

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 65535 }
  validates :started_at, presence: true
  validates :ended_at, presence: true
end
