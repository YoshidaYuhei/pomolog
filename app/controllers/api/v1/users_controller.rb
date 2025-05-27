module Api
  module V1
    class UsersController < BaseController
      skip_before_action :authenticate_by_jwt!, only: [ :create, :login ]

      def create
        user = User.new(user_params)

        if user.save
          access_token = JwtService.encode(user_id: user.id)
          user.refresh_token = JwtService.encode({ user_id: user.id, exp: 14.days.from_now.to_i })
          user.save!
          set_device(user)
          render json: { access_token: }, status: :created
        else
          render json: { message: 'ユーザー登録に失敗しました' }, status: :bad_request
        end
      end

      def login
        user = User.find_by(email: params[:email])
        user.refresh_token = JwtService.encode({ user_id: user.id, exp: 14.days.from_now.to_i })

        if user&.authenticate(params[:password])
          user.save!
          access_token = JwtService.encode(user_id: user.id)
          render json: { access_token: }
        else
          render json: { message: 'ログインに失敗しました' }, status: :unauthorized
        end
      end

      def logout
        current_user.refresh_token = nil
        current_user.save!
        render json: { message: 'ログアウトしました' }, status: :no_content
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
