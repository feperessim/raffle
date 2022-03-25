# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    STATUSES = {
      ActiveRecord::RecordNotFound => :not_found,
      ActiveRecord::RecordInvalid => :unprocessable_entity,
      ActionController::ParameterMissing => :unprocessable_entity
    }.freeze

    include ActionController::HttpAuthentication::Token::ControllerMethods

    rescue_from StandardError, with: :render_standard_error
    rescue_from ActiveRecord::RecordNotFound,
                ActiveRecord::RecordInvalid,
                ActionController::ParameterMissing,
                with: :render_active_record_error

    before_action :authenticate

    private

    def render_standard_error(exception)
      raise exception unless Rails.env.production?
      
      logger.error exception.message
      render_error('Unexpected Error', :internal_server_error)
    end

    def render_active_record_error(exception)
      render_error(exception.message, STATUSES.fetch(exception.class, :internal_server_error))
    end

    def render_error(message, status)
      render json:{ error: message }, status: status
    end

    def authenticate
      authenticate_or_request_with_http_token do |token, _|
        ActiveSupport::SecurityUtils.secure_compare(token, ENV['TOKEN'])
      end
    end
  end
end
