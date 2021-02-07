module Global
  class HomeController < ApiController
    def index
      fetch_user
      feed = Feed.includes(categories: [contents: [:user]]).last
      serialized_feed = serialize_feed(feed)
      insert_latest_content(serialized_feed)
      data = { feeds: serialized_feed }
      render_response(data: data)
    end

    private

    # category_id=-1 // latest content
    def serialize_feed(feed)
      feed.categories.map do |c|
        {
          category_id: c.id,
          category_type: c.category_type,
          title: c.title,
          contents: c.contents.map do |content|
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
      end
    end

    def insert_latest_content(serialized_feed)
      latest_contents = Content.order("id desc").limit(12)
      latest_contents_serialized = latest_contents.map do |content|
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
      latest_category = {
        category_id: -1,
        category_type: 'default',
        title: 'latest posts',
        contents: latest_contents_serialized
      }
      serialized_feed.unshift(latest_category)
    end
  end
end
