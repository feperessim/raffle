# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lottery, type: :model do
  context 'when lottery is valid' do
    subject(:valid_lottery) { described_class.new(raffle_date: Time.now, person:) }
    let(:person) { Person.create!(name: 'Felipe', cpf: '000-000-000-00', birthday: '11/11/2011') }

    it { is_expected.to validate_presence_of(:raffle_date) }
    it { should belong_to(:person) }
    it { is_expected.to be_valid }
  end

  context 'when lottery is not valid' do
    context 'when raffle_date is empty/falsy' do
      subject(:invalid_lottery) { described_class.new(raffle_date: nil, person:) }
      let(:person) { Person.create!(name: 'Felipe', cpf: '000-000-000-00', birthday: '11/11/2011') }

      it { is_expected.not_to be_valid }
    end
    context 'when person does not exist' do
      subject(:invalid_lottery) { described_class.new(raffle_date: Time.now, person: nil) }

      it { is_expected.not_to be_valid }
    end
  end
end
