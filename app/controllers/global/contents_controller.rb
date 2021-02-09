module Global
  class ContentsController < ApiController
    def index
      category = Category.find(params[:category_id])
      results = serialize_category(category)
      render_response(data: results)
    end

    def show
      fetch_user
      content = Content.includes(:user, content_comments: [:user], content_likes: [:user]).find(content_id)
      render_response(data: serialize_content(content))
    end

    def create
      authenticate_user
      created_content = Content.create!(create_content_params)
      render_response(data: { id: created_content.id })
    end

    def update
      authenticate_user
      content = Content.find(content_id)
      if content.user_id != @user.id
        raise 'Forbidden access'
      end
      content.assign_attributes(create_content_params)
      content.save!
      render_response(data: { id: content.id })
    end

    def delete
      authenticate_user
      content = Content.find(content_id)
      if content.user_id != @user.id
        raise 'Forbidden access'
      end
      content.delete
      render_response(data: { id: content.id })
    end

    def popular
      popular_contents = fetch_popular_contents
      render_response(data: popular_contents)
    end

    def recommendation
      recommended_contents = fetch_recomended_contents
      render_response(data: recommended_contents)
    end

    private

    def content_id
      params[:id]
    end

    def category_id
      params[:category_id]
    end

    def create_content_params
      params.permit(:title, :description, :text_content, :image_url, :video_url, :category_id)
        .to_h.merge!(user_id: @user.id)
    end

    def fetch_popular_contents
      contents = Content.includes(:user).order("count_like desc").limit(10)
      contents.map do |content|
        serialize_content(content)
      end
    end

    def fetch_recomended_contents
      contents = Content.includes(:user).where(category_id: category_id).order('RANDOM()').limit(rand(5..10))
      contents.map do |content|
        serialize_content(content)
      end.reject { |c| c[:id] == params[:content_id].to_i }
    end

    def serialize_content(content)
      user_who_likes = content.content_likes.map do |content_like|
        content_like.user.username
      end

      {
        id: content.id,
        category_id: content.category_id,
        content_type: content.content_type,
        title: content.title,
        description: content.description,
        text_content: content.text_content,
        image_url: content.image_url,
        video_url: content.video_url,
        count_like: content.count_like.to_i,
        count_comment: content.count_comment.to_i,
        tag: content.tag,
        creator_id: content.user.id,
        creator_name: content.user.username,
        creator_avatar_url: content.user.generated_avatar_url,
        created_at: content.created_at.localtime.strftime("%Y-%m-%d %H:%M"),
        comments: content.content_comments.map do |comment|
          is_liked = content.liked_by_user(comment.user.id)
          {
            username: comment.user.username,
            avatar_url: comment.user.generated_avatar_url,
            liked_by_me: is_liked,
            comment: comment.comment,
            created_at: comment.created_at.localtime.strftime("%Y-%m-%d %H:%M")
          }
        end,
        liked_by_me: content.liked_by_user(@user&.id),
        category: {
          title: content.category.title
        },
        user_who_likes: user_who_likes.sample(3)
      }
    end

    def serialize_category(category)
      {
        feeds: [
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
                creator_id: content.user.id,
                creator_name: content.user.username,
                creator_avatar_url: content.user.generated_avatar_url,
                created_at: content.created_at.localtime.strftime("%Y-%m-%d %H:%M"),
                liked_by_me: content.liked_by_user(@user&.id)
              }
            end
          }
        ]
      }
    end
  end
end
