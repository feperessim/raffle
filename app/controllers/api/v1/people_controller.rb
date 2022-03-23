# frozen_string_literal: true

module Api
  module V1
    class PeopleController < Api::BaseController
      def index
        @people = Person.all

        render json: @people, status: :ok, each_serializer: Api::V1::PersonSerializer
      end

      def create
        @person = Person.create!(people_params)

        render json: @person, status: :created, serializer: Api::V1::PersonSerializer
      end

      def show
        @person = Person.find(params[:id])

        render json: @person, status: :ok, serializer: Api::V1::PersonSerializer
      end

      def update
        @person = Person.find(params[:id])

        @person.update!(people_params)
        render json: @person, status: :ok, serializer: Api::V1::PersonSerializer
      end

      def destroy
        @person = Person.find(params[:id])

        @person.destroy!
        render json: @person, status: :ok, serializer: Api::V1::PersonSerializer
      end

      private

      def people_params
        params.require(:person).permit(:name, :cpf, :birthday)
      end
    end
  end
end
