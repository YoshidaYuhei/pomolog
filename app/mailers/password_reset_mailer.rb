class PasswordResetMailer < ApplicationMailer
  def password_reset_email(user)
    @user = user
    @reset_url = "#{ENV['FRONTEND_URL']}/reset-password?token=#{user.password_reset_token}"
    mail(
      to: @user.email,
      subject: 'パスワードリセットのご案内'
    )
  end
end
