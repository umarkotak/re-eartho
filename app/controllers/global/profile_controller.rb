module Global
  class ProfileController < ApiController
    def me
      authenticate_user
      render_response(data: serialize_me)
    end

    def info
      render_response(data: serialize_user_info)
    end

    private

    def serialize_me
      contents = Content.includes(:user).where(user_id: @user.id)

      {
        id: @user.id,
        username: @user.username,
        email: @user.email,
        role: @user.role,
        status: @user.status,
        contents: contents.map do |content|
          {
            content_id: content.id,
            content_type: content.content_type,
            title: content.title,
            description: content.description,
            image_url: content.image_url,
            count_like: content.count_like.to_i,
            count_comment: content.count_comment.to_i,
            tag: content.tag,
            creator_name: content.user.username,
            creator_avatar_url: content.user.generated_avatar_url,
            created_at: content.created_at.localtime.strftime("%Y-%m-%d %H:%M"),
            liked_by_me: content.liked_by_user(@user&.id)
          }
        end
      }
    end

    def user_id
      params[:id]
    end

    def selected_user
      selected_user ||= User.find(user_id)
    end

    def serialize_user_info
      contents = Content.includes(:user).where(user_id: selected_user.id)

      {
        id: selected_user.id,
        username: selected_user.username,
        email: selected_user.email,
        role: selected_user.role,
        status: selected_user.status,
        contents: contents.map do |content|
          {
            content_id: content.id,
            content_type: content.content_type,
            title: content.title,
            description: content.description,
            image_url: content.image_url,
            count_like: content.count_like.to_i,
            count_comment: content.count_comment.to_i,
            tag: content.tag,
            creator_name: content.user.username,
            creator_avatar_url: content.user.generated_avatar_url,
            created_at: content.created_at.localtime.strftime("%Y-%m-%d %H:%M"),
            liked_by_me: content.liked_by_user(selected_user&.id)
          }
        end
      }
    end
  end
end
