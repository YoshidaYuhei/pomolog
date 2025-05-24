require 'rails_helper'

RSpec.describe Api::V1::BaseController, type: :controller do
  controller(Api::V1::BaseController) do
    before_action :authenticate_by_jwt!
    def index
      render json: { message: 'success' }
    end
  end

  let(:user) { create(:user) }
  let(:token) { JwtService.encode(user_id: user.id) }

  describe '認証' do
    context '有効なトークンが提供された場合' do
      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      it 'アクションを実行できること' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('success')
      end

      it 'current_userが設定されること' do
        get :index
        expect(assigns(:current_user)).to eq(user)
      end
    end

    context '無効なトークンが提供された場合' do
      before do
        request.headers['Authorization'] = 'Bearer invalid_token'
      end

      it '401エラーを返すこと' do
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('認証に失敗しました')
      end
    end

    context 'トークンが提供されなかった場合' do
      it '401エラーを返すこと' do
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('認証に失敗しました')
      end
    end

    context '存在しないユーザーのトークンが提供された場合' do
      let(:non_existent_user_token) { JwtService.encode(user_id: 999999) }

      before do
        request.headers['Authorization'] = "Bearer #{non_existent_user_token}"
      end

      it '401エラーを返すこと' do
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('認証に失敗しました')
      end
    end
  end
end
