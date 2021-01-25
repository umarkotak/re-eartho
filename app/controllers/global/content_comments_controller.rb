module Global
  class ContentCommentsController < ApiController
    def index
      comments = ContentComment.where(content_id: content_id)
      render_response(data: serialize_comments(comments))
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

    def serialize_comments(comments)
      comments.map do |comment|
        is_liked = content.liked_by_user(comment.user.id)
        {
          username: comment.user.username,
          avatar_url: comment.user.generated_avatar_url,
          liked_by_me: is_liked,
          comment: comment.comment,
          created_at: comment.created_at.localtime.strftime("%Y-%m-%d %H:%M")
        }
      end
    end
  end
end
