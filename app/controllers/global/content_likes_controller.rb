module Global
  class ContentLikesController < ApiController
    def like
      authenticate_user
    end

    def unlike
      authenticate_user
    end
  end
end
