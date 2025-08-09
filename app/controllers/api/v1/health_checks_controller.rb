module Api
  module V1
    class HealthChecksController < BaseController
      # skip_before_action :authenticate_by_jwt!
      def index
        message = HealthCheck.first.message
        render json: { message: }
      end
    end
  end
end
