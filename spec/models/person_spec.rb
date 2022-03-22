# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person, type: :model do
  context 'when person is valid' do
    subject(:valid_person) { described_class.new(name: 'Felipe', cpf: '000.000.000-00', birthday: '00/00/00') }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:cpf) }
    it { is_expected.to validate_uniqueness_of(:cpf).case_insensitive }
    it { is_expected.to be_valid }
  end

  context 'when person is not valid' do
    context 'when name is empty/falsy' do
      subject(:invalid_person) { described_class.new(name: nil, cpf: '000.000.000-00', birthday: '00/00/00') }

      it { is_expected.not_to be_valid }
    end
    context 'when cpf is empty/falsy' do
      subject(:invalid_person) { described_class.new(name: 'Felipe', cpf: nil, birthday: '00/00/00') }

      it { is_expected.not_to be_valid }
    end

    context 'when cpf not unique' do
      subject(:invalid_person) { described_class.new(name: 'Felipe', cpf: '000.000.000-00', birthday: '00/00/00') }
      before do
        described_class.create!(name: 'Felipe', cpf: '000.000.000-00', birthday: '00/00/00')
      end

      it { is_expected.not_to be_valid }
    end
  end
end
