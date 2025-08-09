require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'POST /api/v1/diaries' do
    subject { post '/api/v1/diaries', headers:, params:, as: :json }
    let(:headers) do
      {
        'Content-Type' => 'application/json',
        'Os_Type' => 'ios'
      }.merge!(auth_headers)
    end

    let(:params) do
      {
        title: 'test_title',
        content: 'test_content',
        started_at: '2021-01-01 00:00:00',
        ended_at: '2021-01-01 01:00:00'
      }
    end

    context '正常系' do
      it '日記が作成されること' do
        aggregate_failures do
          expect { subject }.to(
            change(Diary, :count).by(1)
          )
          expect(response).to have_http_status(204)
          diary = Diary.last
          expect(diary.title).to eq(params[:title])
          expect(diary.content).to eq(params[:content])
          expect(diary.started_at).to eq(params[:started_at])
          expect(diary.ended_at).to eq(params[:ended_at])
        end
      end
    end

    context 'パラメータが不正な場合' do
      before do
        allow_any_instance_of(Diary).to receive(:save) do |diary|
          diary.errors.add(:base, 'foo')
          false
        end
      end

      it '日記が作成されず、エラーメッセージが返されること' do
        aggregate_failures do
          expect { subject }.to(
            change(Diary, :count).by(0)
          )
          expect(response).to have_http_status(400)
        end
      end
    end
  end
end