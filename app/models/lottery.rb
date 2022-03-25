# frozen_string_literal: true

class Lottery < ApplicationRecord
  belongs_to :person
  validates :raffle_date, presence: true
  alias winner person
end
