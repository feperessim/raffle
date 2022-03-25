# frozen_string_literal: true

module Api
  module V1
    class LotterySerializer < ActiveModel::Serializer
      attributes :raffle_date, :winner

      has_one :winner, serializer: Api::V1::PersonSerializer
    end
  end
end
