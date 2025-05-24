require 'rails_helper'

RSpec.describe PasswordResetMailer, type: :mailer do
  describe '#password_reset_email' do
    let(:user) { create(:user, reset_passowrd_token: 'abc123') }
    let(:mail) { described_class.password_reset_email(user) }

    it 'メールアドレスが正しい' do
      expect(mail.to).to eq([ user.email ])
    end

    it '件名が正しい' do
      expect(mail.subject).to eq('パスワードリセットのご案内')
    end

    it 'リセットリンクが含まれる' do
      expect(mail.body.encoded).to include("#{ENV['FRONTEND_URL']}/reset-password?token=abc123")
    end
  end
end
