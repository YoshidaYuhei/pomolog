require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'Os_Type' => 'ios',
      'X-Device-ID' => 'test_device_id'
    }
  end
  describe 'POST /api/v1/users/signup' do
    subject { post '/api/v1/users/signup', headers:, params:, as: :json }

    let(:params) do
      {
        email: 'test@example.com',
        password: 'password'
      }
    end

    context '正常系' do
      it 'レコードを作成し、トークンを返すこと' do
        aggregate_failures do
          expect { subject }.to(
            change(User, :count).by(1)
            .and(change(Device, :count).by(1))
          )
          expect(response).to have_http_status(201)
          expect(response.parsed_body['access_token']).to be_a(String)
        end
      end
    end

    context 'デバイスIDがパラメータにない場合' do
      let(:params) do
        {
          password: 'password',
          password_confirmation: 'password'
        }
      end
      it '400エラーを返すこと' do
        aggregate_failures do
          expect { subject }.to(
            change(User, :count).by(0)
            .and(change(Device, :count).by(0))
          )
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'POST /api/v1/users/login' do
    subject { post '/api/v1/users/login', headers:, params:, as: :json }
    let(:params) do
      {
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end
    before do
      create(
        :user,
        email: params[:email],
        password: params[:password]
      )
    end

    context '正常系' do
      it 'レコードを作成し、トークンを返すこと' do
        aggregate_failures do
          subject
          expect(response).to have_http_status(200)
          expect(response.parsed_body['access_token']).to be_a(String)
        end
      end
    end
  end

  describe 'POST /api/v1/users/logout' do
    subject { post '/api/v1/users/logout', headers:, as: :json }
    let(:current_user) { create(:user, :with_refresh_token) }
    before do
      headers.merge!(auth_headers(current_user))
    end

    context '正常系' do
      it 'リフレッシュトークンが削除されること' do
        aggregate_failures do
          subject
          expect(response).to have_http_status(:no_content)
          expect(current_user.reload.refresh_token).to be_nil
        end
      end
    end
  end
end
