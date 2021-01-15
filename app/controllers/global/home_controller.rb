module Global
  class HomeController < ApiController
    def index
      feed = Feed.last
      feed_data = feed.categories.map do |c|
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
              count_comment: 0
            }
          end
        }
      end

      data = { feeds: feed_data }
      render_response(data: data)
    end
  end
end
