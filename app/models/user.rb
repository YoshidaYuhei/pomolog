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
class User < ApplicationRecord
  has_secure_password

  has_many :devices, dependent: :destroy, inverse_of: :user
  has_one :user_profile, dependent: :destroy, inverse_of: :user

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, if: :password_digest_changed?
  validates :password, confirmation: true

  def generate_password_reset_token!
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.current
    save!
  end

  def clear_password_reset_token!
    update!(password_reset_token: nil, password_reset_sent_at: nil)
  end

  def password_reset_token_expired?
    password_reset_sent_at < 2.hours.ago
  end
end
