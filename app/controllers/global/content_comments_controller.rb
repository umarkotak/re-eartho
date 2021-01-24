module Global
  class ContentCommentsController < ApiController
    def index
      result = []
      render_response(data: result)
    end

    def comment
      authenticate_user
      content.transaction do
        content.update!(count_comment: content.count_comment.to_i + 1)
        ContentComment.create!(content_id: content.id, user_id: @user.id, comment: params[:comment])
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
