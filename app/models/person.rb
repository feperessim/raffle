# frozen_string_literal: true

class Person < ApplicationRecord
  has_one :lottery, dependent: :destroy
  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true

  scope :not_drawn_people, -> { all_active.left_outer_joins(:lottery).where(lottery: { person_id: nil }) }
  scope :all_active, -> { where(active: true) }

  def self.random_draw
    order('RANDOM()').first!
  end
end
