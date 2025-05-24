module Api
  module V1
    class PasswordResetsController < BaseController
      skip_before_action :authenticate_by_jwt!, only: [ :create, :edit, :update ]

      # POST /api/v1/password_resets
      def create
        user = User.find_by(email: params[:email])
        if user
          user.generate_password_reset_token!
          PasswordResetMailer.with(user:).password_reset_email.deliver_later
        end
        render json: { message: 'パスワードリセット用のメールを送信しました' }, status: :no_content
      end

      # GET /api/v1/password_resets/:token
      def edit
        user = User.find_by(password_reset_token: params[:token])
        if user && user.password_reset_token_expired?
          render json: { message: 'パスワードリセット用のメールを送信しました' }, status: :no_content
        else
          render json: { message: 'パスワードリセット用のメールを送信しました' }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/password_resets/:token
      def update
        user = User.find_by(password_reset_token: params[:token])
        if user && user.password_reset_token_expired?
          user.update(password: params[:password], password_reset_token: nil, password_reset_sent_at: nil)
          render json: { message: 'パスワードを更新しました' }, status: :ok
        else
          render json: { message: 'パスワードリセット用のメールを送信しました' }, status: :unprocessable_entity
        end
      end

      def forgot_password
        user = User.find_by(email: params[:email])
        if user
          user.reset_passowrd_token = SecureRandom.hex(20)
          user.reset_passowrd_sent_at = Time.current
          if user.save
            PasswordResetMailer.password_reset_email(user).deliver_now
            render json: { message: 'パスワードリセット用のメールを送信しました' }, status: :ok
          else
            render json: { message: 'パスワードリセットの処理に失敗しました' }, status: :unprocessable_entity
          end
        else
          render json: { message: 'メールアドレスが見つかりません' }, status: :not_found
        end
      end

      def reset_password
        user = User.find_by(reset_passowrd_token: params[:token])

        if user && user.reset_passowrd_sent_at > 24.hours.ago
          if user.update(password: params[:password], reset_passowrd_token: nil, reset_passowrd_sent_at: nil)
            render json: { message: 'パスワードを更新しました' }, status: :ok
          else
            render json: { message: 'パスワードの更新に失敗しました' }, status: :unprocessable_entity
          end
        else
          render json: { message: '無効なトークンか、有効期限が切れています' }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:email, :password)
      end

      def set_device(user)
        return if device_id.blank?

        Device.create!(
          key: device_id,
          os_type:,
          user:
        )
      end
    end
  end
end
