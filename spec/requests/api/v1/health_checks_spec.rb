require 'rails_helper'

RSpec.describe 'Api::V1::HealthChecks', type: :request do
  describe 'GET /api/v1/health_checks' do
    subject { get '/api/v1/health_checks', headers:, params: }

    let(:headers) do
      {
        'Content-Type' => 'application/json',
        'Os_Type' => 'ios'
      }.merge!(auth_headers)
    end

    let(:params) { { device_id: 'test_device_id' } }
    it 'returns a 200 status code' do
      subject
      expect(response).to have_http_status(200)
      expect(response.parsed_body['message']).to eq('OK')
    end
  end
end
