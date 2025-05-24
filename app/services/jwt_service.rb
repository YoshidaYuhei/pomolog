class JwtService
  class << self
    def encode(payload)
      JWT.encode(payload, secret_key, 'HS256')
    end

    def decode(token)
      JWT.decode(token, secret_key, true, algorithm: 'HS256')[0]
    rescue JWT::DecodeError, JWT::ExpiredSignature
      nil
    end

    private

    def secret_key
      Rails.application.credentials.secret_key_base
    end
  end
end
