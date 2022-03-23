# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record_response
    rescue_from ActionController::ParameterMissing, with: :render_parameter_missing_response

    private

    def render_not_found_response(exception)
      render json: { error: exception.message }, status: :not_found
    end

    def render_invalid_record_response(exception)
      render json: { error: exception.message }, status: :unprocessable_entity
    end

    def render_parameter_missing_response(exception)
      render json: { error: exception.message }, status: :unprocessable_entity
    end
  end
end
