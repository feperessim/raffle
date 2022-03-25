# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api/v1/people', type: :request do
  describe 'GET /api/v1/people' do
    it 'returns http status success' do
      get api_v1_people_path
      expect(response).to have_http_status(:success)
    end

    let(:people) do
      [
        { name: 'Isaac Newton', cpf: '000.001.003-05', birthday: '1943-01-04' },
        { name: 'Leonhard Euler', cpf: '271.828.182-84', birthday: '1707-04-15' },
        { name: 'Felipe', cpf: '000.000.000', birthday: '1900-01-01' }
      ]
    end

    before do
      Person.create!(name: 'Isaac Newton', cpf: '000.001.003-05', birthday: '1943-01-04')
      Person.create!(name: 'Leonhard Euler', cpf: '271.828.182-84', birthday: '1707-04-15')
      Person.create!(name: 'Felipe', cpf: '000.000.000', birthday: '1900-01-01')
    end

    it 'returns the expected response body' do
      get api_v1_people_path

      expect(response.body).to eq(people.to_json)
    end
  end

  describe 'POST /api/v1/people' do
    context 'when person params are valid' do
      it 'creates a new person' do
        expect do
          post api_v1_people_path, params: { person: { name: 'New Person', cpf: '000.000.000-00' } }
        end.to change { Person.count }.by(1)
      end

      it 'returns http status created' do
        post api_v1_people_path, params: { person: { name: 'New Person', cpf: '000.000.000-00' } }

        expect(response).to have_http_status(:created)
      end

      it 'returns the expected response body' do
        post api_v1_people_path, params: { person: { name: 'New Person', cpf: '000.000.000-00' } }

        expect(response.body).to eq({ name: 'New Person', cpf: '000.000.000-00', birthday: nil }.to_json)
      end
    end

    context 'when person params are missing' do
      it 'returns http status unprocessable entity' do
        post api_v1_people_path, params: nil

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the expected response body' do
        post api_v1_people_path, params: nil

        expect(response.body).to eq({ error: 'param is missing or the value is empty: person' }.to_json)
      end
    end

    context 'when person params are not valid' do
      context 'when person name is missing' do
        it 'returns http status unprocessable entity' do
          post api_v1_people_path, params: { person: { name: nil, cpf: '000.000.000-00' } }

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the expected response body' do
          post api_v1_people_path, params: { person: { name: nil, cpf: '000.000.000-00' } }

          expect(response.body).to eq({ error: "Validation failed: Name can't be blank" }.to_json)
        end
      end

      context 'when person cpf is missing' do
        it 'returns http status unprocessable entity' do
          post api_v1_people_path, params: { person: { name: 'New Person', cpf: nil, birthday: nil } }

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the expected response body' do
          post api_v1_people_path, params: { person: { name: 'New Person', cpf: nil, birthday: nil } }

          expect(response.body).to eq({ error: "Validation failed: Cpf can't be blank" }.to_json)
        end
      end

      context 'when person cpf is not unique' do
        before do
          Person.create!(name: 'Nameless', cpf: '000.000.000-00', birthday: '1943-01-04')
        end
        it 'returns http status unprocessable entity' do
          post api_v1_people_path, params: { person: { name: 'New Person', cpf: '000.000.000-00', birthday: nil } }

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the expected response body' do
          post api_v1_people_path, params: { person: { name: 'New Person', cpf: '000.000.000-00', birthday: nil } }

          expect(response.body).to eq({ error: 'Validation failed: Cpf has already been taken' }.to_json)
        end
      end
    end
  end

  describe 'GET /api/v1/person/:id' do
    context 'when person exists' do
      let(:person) { Person.create!(name: 'Nameless', cpf: '000.000.000-00', birthday: '2011-11-11') }

      it 'returns http status success' do
        get api_v1_person_path(person)

        expect(response).to have_http_status(:success)
      end

      it 'returns the expected response body' do
        get api_v1_person_path(person)

        expect(response.body).to eq({ name: 'Nameless', cpf: '000.000.000-00', birthday: '2011-11-11' }.to_json)
      end
    end

    context 'when person does not exist' do
      it 'returns http status not found' do
        get api_v1_person_path({ id: 0 })

        expect(response).to have_http_status(:not_found)
      end

      it 'returns the expected response body' do
        get api_v1_person_path({ id: 0 })

        expect(response.body).to eq({ error: "Couldn't find Person with 'id'=0" }.to_json)
      end
    end
  end

  describe 'PATCH /api/v1/person/:id' do
    context 'when person exists' do
      let!(:person) { Person.create!(name: 'Nameless', cpf: '000.000.000-00', birthday: '2011-11-11') }

      it 'updates person' do
        expect do
          patch api_v1_person_path(person),
                params: { person: { name: 'New name', cpf: '000.000.000-00', birthday: '2011-11-11' } }
        end.to change { Person.first.name }
      end

      it 'returns http status success' do
        patch api_v1_person_path(person),
              params: { person: { name: 'New name', cpf: '000.000.000-00', birthday: '2011-11-11' } }

        expect(response).to have_http_status(:success)
      end

      it 'returns the expected response body' do
        patch api_v1_person_path(person),
              params: { person: { name: 'New name', cpf: '000.000.000-00', birthday: '2011-11-11' } }

        expect(response.body).to eq({ name: 'New name', cpf: '000.000.000-00', birthday: '2011-11-11' }.to_json)
      end
    end

    context 'when person does not exist' do
      it 'returns http status not found' do
        patch api_v1_person_path({ id: 0 }),
              params: { person: { name: 'New name', cpf: '000.000.000-00', birthday: '2011-11-11' } }

        expect(response).to have_http_status(:not_found)
      end

      it 'returns the expected response body' do
        patch api_v1_person_path({ id: 0 }),
              params: { person: { name: 'New name', cpf: '000.000.000-00', birthday: '2011-11-11' } }

        expect(response.body).to eq({ error: "Couldn't find Person with 'id'=0" }.to_json)
      end
    end
  end

  describe 'DELETE /api/v1/person/:id' do
    context 'when person exists' do
      let!(:person) { Person.create!(name: 'Nameless', cpf: '000.000.000-00', birthday: '2011-11-11', active: true) }

      it 'deletes person (turns it inactive)' do
        expect do
          delete api_v1_person_path(person)
        end.to change { Person.first.active }
      end

      it 'returns http status success' do
        delete api_v1_person_path(person)

        expect(response).to have_http_status(:success)
      end

      it 'returns the expected response body' do
        delete api_v1_person_path(person)

        expect(response.body).to eq({ name: 'Nameless', cpf: '000.000.000-00', birthday: '2011-11-11' }.to_json)
      end
    end

    context 'when person does not exist' do
      it 'returns http status not found' do
        delete api_v1_person_path({ id: 0 })

        expect(response).to have_http_status(:not_found)
      end

      it 'returns the expected response body' do
        patch api_v1_person_path({ id: 0 })

        expect(response.body).to eq({ error: "Couldn't find Person with 'id'=0" }.to_json)
      end
    end
  end
end
