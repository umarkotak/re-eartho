class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from StandardError, with: :rescue_standard_error

  def fetch_user
    @user = User.find_by("session_key = :session_key", session_key: request.headers['Authorization'])
  end

  def authenticate_user
    @user = User.find_by("session_key = :session_key", session_key: request.headers['Authorization'])
    return if @user
    raise 'Unauthorized request'
  rescue StandardError => e
    raise "Unauthorized request : #{e.message}"
  end

  def render_response(data: {}, success: true, errors: [], status: 200)
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, PUT, DELETE'
    response.headers['Access-Control-Allow-Headers'] = 'Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization'

    json = {
      data: data,
      success: success,
      errors: errors
    }
    render json: json, status: status
  end

  def rescue_standard_error(exception)
    Rails.logger.error("[ERROR STACK TRACE]: #{exception.message}")
    render_response(
      data: {},
      success: false,
      errors: [
        exception.message
      ],
      status: 500
    )
  end
end
