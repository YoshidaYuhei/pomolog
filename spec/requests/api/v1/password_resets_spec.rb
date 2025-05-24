require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'Os_Type' => 'ios'
    }
  end

  describe "POST /password_resets" do
    subject { post '/api/v1/password_resets', headers:, params:, as: :json }
    context 'email が存在する場合' do
      let!(:current_user) { create(:user) }
      let(:params) { { email: current_user.email } }
      before { headers.merge!(auth_headers(current_user)) }

      it "リセットトークンを保存する" do
        expect {
          subject
        }.to change { current_user.reload.password_reset_token_before_type_cast }.from(nil)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'email が存在しない場合' do
      let!(:current_user) { create(:user) }
      let(:params) { { email: "nonexistent@example.com" } }
      it "リセットトークンを保存しない" do
        expect {
          subject
        }.not_to change { current_user.reload.password_reset_token_before_type_cast }
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
