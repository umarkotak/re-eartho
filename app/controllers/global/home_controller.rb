module Global
  class HomeController < ApiController
    def index
      data = { feeds: [] }
      render_response(data: data)
    end
  end
end
