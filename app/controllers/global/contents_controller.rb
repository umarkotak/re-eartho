module Global
  class ContentsController < ApiController
    def show
      content = Content.includes(:user, content_comments: [:user]).find(content_id)
      render_response(data: serialize_content(content))
    end

    private

    def content_id
      params[:id]
    end

    def serialize_content(content)
      {
        content_type: content.content_type,
        title: content.title,
        description: content.description,
        text_content: content.text_content,
        image_url: content.image_url,
        video_url: content.video_url,
        count_like: content.count_like,
        count_comment: content.count_comment,
        tag: content.tag,
        creator_name: content.user.username,
        created_at: content.created_at.localtime.strftime("%Y-%m-%d %H:%M"),
        comments: content.content_comments.map do |comment|
          {
            username: comment.user.username,
            comment: comment.comment,
            created_at: comment.created_at.localtime.strftime("%Y-%m-%d %H:%M")
          }
        end
      }
    end
  end
end
