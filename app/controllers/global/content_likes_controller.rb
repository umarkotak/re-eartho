module Global
  class ContentLikesController < ApiController
    def like
      authenticate_user

      content_like = ContentLike.find_by(content_id: content.id, user_id: @user.id)
      raise "user already like this content" if content_like.present?

      content.transaction do
        content.update!(count_like: content.count_like.to_i + 1)
        ContentLike.create!(content_id: content.id, user_id: @user.id)
      end
      render_response(data: { id: content.id })
    end

    def unlike
      authenticate_user

      content_like = ContentLike.find_by(content_id: content.id, user_id: @user.id)
      raise "user have not like this content" if content_like.blank?

      content.transaction do
        content.update!(count_like: content.count_like.to_i - 1)
        content_like.delete
      end
      render_response(data: { id: content.id })
    end

    private

    def content
      @content ||= Content.find(content_id)
    end

    def content_id
      params[:id]
    end
  end
end
