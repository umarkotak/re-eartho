class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

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
end
