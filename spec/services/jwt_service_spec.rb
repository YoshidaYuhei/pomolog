require 'rails_helper'

RSpec.describe JwtService do
  let(:payload) { { user_id: 1 } }
  let(:token) { described_class.encode(payload) }

  describe '.encode' do
    it 'JWTトークンを生成できること' do
      expect(token).to be_a(String)
    end
  end

  describe '.decode' do
    it '有効なトークンをデコードできること' do
      decoded = described_class.decode(token)
      expect(decoded['user_id']).to eq(payload[:user_id])
    end

    it '無効なトークンの場合はnilを返すこと' do
      expect(described_class.decode('invalid_token')).to be_nil
    end

    it '期限切れのトークンの場合はnilを返すこと' do
      expired_token = JWT.encode(
        { user_id: 1, exp: 1.hour.ago.to_i },
        Rails.application.credentials.secret_key_base,
        'HS256'
      )
      expect(described_class.decode(expired_token)).to be_nil
    end
  end
end
