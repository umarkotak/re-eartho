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
      categories = Category.includes(:contents).where(contents: { user_id: @user.id }).to_a

      {
        id: @user.id,
        username: @user.username,
        email: @user.email,
        role: @user.role,
        status: @user.status,
        categories: categories.map do |category|
          {
            category_id: category.id,
            category_type: category.category_type,
            title: category.title,
            contents: category.contents.map do |content|
              {
                content_id: content.id,
                content_type: content.content_type,
                title: content.title,
                description: content.description,
                image_url: content.image_url,
                count_like: content.count_like.to_i,
                count_comment: content.count_comment.to_i,
                tag: content.tag,
                creator_id: content.user_id,
                creator_name: content.user.username,
                creator_avatar_url: content.user.generated_avatar_url,
                created_at: content.created_at.localtime.strftime("%Y-%m-%d %H:%M"),
                liked_by_me: content.liked_by_user(@user&.id)
              }
            end
          }
        end
      }
    end

    def user_id
      params[:id]
    end

    def selected_user
      @selected_user ||= User.find(user_id)
    end

    def serialize_user_info
      categories = Category.includes(contents: [:user]).where(contents: { user_id: selected_user.id }).to_a

      {
        id: selected_user.id,
        username: selected_user.username,
        email: selected_user.email,
        role: selected_user.role,
        status: selected_user.status,
        categories: categories.map do |category|
          {
            category_id: category.id,
            category_type: category.category_type,
            title: category.title,
            contents: category.contents.map do |content|
              {
                content_id: content.id,
                content_type: content.content_type,
                title: content.title,
                description: content.description,
                image_url: content.image_url,
                count_like: content.count_like.to_i,
                count_comment: content.count_comment.to_i,
                tag: content.tag,
                creator_id: content.user_id,
                creator_name: content.user.username,
                creator_avatar_url: content.user.generated_avatar_url,
                created_at: content.created_at.localtime.strftime("%Y-%m-%d %H:%M"),
                liked_by_me: content.liked_by_user(selected_user&.id, selected_user&.liked_content_ids)
              }
            end
          }
        end
      }
    end
  end
end
