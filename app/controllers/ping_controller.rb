class PingController < ApplicationController
  def ping
    data = { ping: 'pong' }
    render_response(data: data)
  end
end
