# frozen_string_literal: true

module Api
  module V1
    class LotteriesController < Api::BaseController
      class NotEligibleError < ActiveRecord::RecordNotFound; end

      rescue_from NotEligibleError do
        render_error('There are no eligible people to be drawn', :precondition_failed)
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
      raise NotEligibleError
    end
    end
  end
end
