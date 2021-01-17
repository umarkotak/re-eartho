module Global
  class HomeController < ApiController
    def index
      feed = Feed.includes(categories: [contents: [:user]]).last
      data = { feeds: serialize_feed(feed) }
      render_response(data: data)
    end

    private

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
              count_like: 0,
              count_comment: 0,
              tag: content.tag,
              creator_name: content.user.username,
              created_at: content.created_at.localtime.strftime("%Y-%m-%d %H:%M")
            }
          end
        }
      end
    end
  end
end
