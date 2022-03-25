# frozen_string_literal: true

module Api
  module V1
    class LotteriesController < Api::BaseController    
      class NoEligibleError < ActiveRecord::RecordInvalid; end

      rescue_from NoEligibleError do
        render_error('There are no eligible people to be drawn', :precondition_failed)
      end
      
      def create
        @person = Person.not_drawn_people.random_draw
      
        @lottery = create_lottery!
        render json: @lottery, status: :created, serializer: Api::V1::LotterySerializer
      end

    private

    def create_lottery!
      Lottery.create!(person: @person, raffle_date: Time.now)
    rescue ActiveRecord::RecordInvalid
      raise NoEligibleError
    end
    end
  end
end
