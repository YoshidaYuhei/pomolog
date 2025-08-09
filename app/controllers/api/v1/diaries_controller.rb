module Api
  module V1
    class DiariesController < BaseController
      def create
        @diary = Diary.new(create_params)

        if @diary.save
          render body: nil, status: :no_content
        else
          message = @diary.errors.full_messages
          render json: { message: }, status: :bad_request
        end
      end

      private

      def create_params
        user_id = current_user.id
        params.permit(:title, :content, :started_at, :ended_at).merge(user_id:)
      end
    end
  end
end
