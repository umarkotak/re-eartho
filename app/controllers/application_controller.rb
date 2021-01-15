class ApplicationController < ActionController::Base
  def render_response(data: {}, success: true, errors: [], status: 200)
    json = {
      data: data,
      success: success,
      errors: errors
    }
    render json: json, status: status
  end
end
