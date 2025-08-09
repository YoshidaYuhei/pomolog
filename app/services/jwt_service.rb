class JwtService
  class << self
    def encode(payload)
      JWT.encode(payload, secret_key, 'HS256')
    end

    def decode(token)
      Rails.logger.debug "Attempting to decode token: #{token}"
      Rails.logger.debug "Using secret_key: #{secret_key}"
      
      decoded = JWT.decode(token, secret_key, true, algorithm: 'HS256')[0]
      Rails.logger.debug "Successfully decoded token: #{decoded}"
      decoded
    rescue JWT::ExpiredSignature => e
      Rails.logger.error "Token expired: #{e.message}"
      { error: 'トークンの有効期限が切れています' }
    rescue JWT::DecodeError => e
      Rails.logger.error "Token decode error: #{e.message}"
      { error: "トークンのデコードに失敗しました: #{e.message}" }
    end

    private

    def secret_key
      ENV['SECRET_KEY_BASE'] || Rails.application.credentials.secret_key_base
    end
  end
end
