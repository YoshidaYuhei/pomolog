class Api::V1::BaseController < ApplicationController
  before_action :authenticate_by_jwt!
  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::ReadOnlyRecord, with: :bad_request
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from ActionController::BadRequest, with: :bad_request


  private

  def authenticate_by_jwt!
    header = request.headers['Authorization']
    return render_auth_error unless header

    token = header.split(' ').last
    return render_auth_error unless token

    begin
      decoded = JwtService.decode(token)
      return render_auth_error unless decoded

      @_current_user = User.find(decoded['user_id'])
    rescue ActiveRecord::RecordNotFound
      render_auth_error
    end
  end

  def render_auth_error
    render json: { error: '認証に失敗しました' }, status: :unauthorized
  end

  def current_user
    @_current_user
  end

  protected

  def os_type
    @os_type ||= request.headers['Os_Type']
  end

  def device_id
    @device_id ||= request.headers['X-Device-ID']
  end
end
