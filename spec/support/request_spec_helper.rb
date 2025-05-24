module RequestSpecHelper
  def auth_headers(user = nil)
    user ||= create(:user)
    token = JwtService.encode(user_id: user.id)
    { 'Authorization' => "Bearer #{token}" }
  end

  def auth_headers_with_invalid_token
    { 'Authorization' => 'Bearer invalid_token' }
  end

  def auth_headers_with_expired_token
    expired_token = JWT.encode(
      { user_id: 1, exp: 1.hour.ago.to_i },
      Rails.application.credentials.secret_key_base,
      'HS256'
    )
    { 'Authorization' => "Bearer #{expired_token}" }
  end
end
