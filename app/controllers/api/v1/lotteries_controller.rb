# frozen_string_literal: true

module Api
  module V1
    class LotteriesController < Api::BaseController
      class NoEligibleError < ActiveRecord::RecordNotFound; end

      rescue_from NoEligibleError do
        render_error('There are no eligible people to be drawn', :precondition_failed)
      end

      def index
        @lotteries = Lottery.all

        render json: @lotteries, status: :ok, each_serializer: Api::V1::LotterySerializer
      end

      def create
        @person = random_draw
        @lottery = Lottery.create!(person: @person, raffle_date: Time.now)

        render json: @lottery, status: :created, serializer: Api::V1::LotterySerializer
      end

      private

      def random_draw
        @person = Person.not_drawn_people.random_draw
      rescue ActiveRecord::RecordNotFound
        raise NoEligibleError
      end
    end
  end
end
