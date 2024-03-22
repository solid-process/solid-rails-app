# frozen_string_literal: true

module API::V1
  class BaseController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods

    rescue_from ActionController::ParameterMissing do |exception|
      render_json_with_error(status: :bad_request, message: exception.message)
    end

    rescue_from StandardError do |exception|
      Rails.error.report(exception, source: "api/v1")

      message = Rails.env.production? ? "Internal Server Error" : exception.message

      render_json_with_error(status: :internal_server_error, message:)
    end

    before_action :authenticate_user!

    protected

    def authenticate_user!
      return if current_user

      render_json_with_error(status: :unauthorized, message: "Invalid access token")
    end

    def current_user
      @current_user ||= authenticate_with_http_token do |access_token|
        User.joins(:token).find_by(user_tokens: {access_token:})
      end
    end

    def render_json_with_success(status:, data: nil)
      json = {status: :success}

      case data
      when ::Hash then json[:type] = :object
      when ::Array then json[:type] = :collection
      end

      json[:data] = data if data

      render status:, json:
    end

    def render_json_with_error(status:, message:, details: {})
      render status:, json: {status: :error, message:, details:}
    end

    def render_json_with_record_errors(record)
      message = record.errors.full_messages.join(", ")
      details = record.errors.messages

      render_json_with_error(status: :unprocessable_entity, message:, details:)
    end
  end
end
