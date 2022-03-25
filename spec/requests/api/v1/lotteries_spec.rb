# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api/v1/lotteries', type: :request do
  describe 'POST /api/v1/lotteries' do
    before do
      stub_const("Api::BaseController::AUTH_TOKEN", '1234')
    end

    context 'when the Authorization header is valid' do
      let(:headers) { { Authorization: 'Token 1234' } }

      context 'when there are people eligible for lottering' do
        let(:people) do
          [
            { 'name' => 'Isaac Newton', 'cpf' => '000.001.003-05', 'birthday' => '1943-01-04' },
            { 'name' => 'Leonhard Euler', 'cpf' => '271.828.182-84', 'birthday' => '1707-04-15' },
            { 'name' => 'Felipe', 'cpf' => '000.000.000', 'birthday' => '1900-01-01' }
          ]
        end

        before do
          Person.create!(name: 'Isaac Newton', cpf: '000.001.003-05', birthday: '1943-01-04')
          Person.create!(name: 'Leonhard Euler', cpf: '271.828.182-84', birthday: '1707-04-15')
          Person.create!(name: 'Felipe', cpf: '000.000.000', birthday: '1900-01-01')
        end

        it 'creates a new lottery' do
          expect do
            post api_v1_lotteries_path, headers: headers
          end.to change { Lottery.count }.by(1)
        end

        it 'returns http status created' do
          post api_v1_lotteries_path, headers: headers

          expect(response).to have_http_status(:created)
        end

        it 'returns the expected response body' do
          post api_v1_lotteries_path, headers: headers

          expect(people).to include(JSON.parse(response.body)['winner'])
        end
      end

      context 'when there are no people eligible for lottering' do
        it 'does not create a new lottery' do
          expect do
            post api_v1_lotteries_path, headers: headers
          end.not_to change { Lottery.count }
        end

        it 'returns http status :precondition_failed' do
          post api_v1_lotteries_path, headers: headers

          expect(response).to have_http_status(:precondition_failed)
        end
        it 'returns the expected response body' do
          post api_v1_lotteries_path, headers: headers

          expect(response.body).to eq({ "error": 'There are no eligible people to be drawn' }.to_json)
        end
      end
    end

    context 'when the Authorization header is not valid' do
      let(:headers) { { Authorization: 'Token invalid' } }

      it 'does not create a new lottery' do
        expect do
          post api_v1_lotteries_path, headers: headers
        end.not_to change { Lottery.count }
      end

      it 'returns http status unauthorized' do
        post api_v1_lotteries_path, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the expected response body' do
        post api_v1_lotteries_path, headers: headers

        expect(response.body).to eq("HTTP Token: Access denied.\n")
      end
    end
  end
end
