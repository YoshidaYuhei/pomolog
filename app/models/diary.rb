class Diary < ApplicationRecord
  belongs_to :user, inverse_of: :diaries

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 65535 }
  validates :started_at, presence: true
  validates :ended_at, presence: true
end
