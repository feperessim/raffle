# frozen_string_literal: true

class Person < ApplicationRecord
  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true
end
