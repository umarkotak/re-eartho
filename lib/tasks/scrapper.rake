require 'digest'

namespace :scrapper do
  # exec sample: bin/rake 'scrapper:youtube'
  desc 'scrap youtube data'
  task :youtube => :environment do |_task, args|
    puts "START SCRAPPING YOUTUBE DATA #{Time.now}"

    c = Category.create(category_type: 'default', title: 'curiosity', position: '6', tag: 'none', feed_id: Feed.first.id)

    items = []
    nextPageToken = nil
    host = 'https://www.googleapis.com/youtube/v3/search?'

    for i in 1..1 do
      params = [
        'key=AIzaSyDL9jzmqn7zo2EDs0LGT82wu3_sQykZqaE',
        'channelId=UCsXVk37bltHxD1rDPwtNM8Q',
        'part=snippet,id',
        'order=date',
        'maxResults=50'
      ]
      params << "pageTokenq=#{@nextPageToken}" if @nextPageToken
      url_builder = host + params.join('&')

      target_url = URI.parse(url_builder)
      response = Net::HTTP.get(target_url)
      response_parsed = JSON.parse(response, symbolize_names: true)
      nextPageToken = response_parsed[:nextPageToken]
      items += response_parsed[:items].map do |item|
        # next if !item[:snippet][:title].include?('[English Sub]')
        creation_params = {
          title: item[:snippet][:title],
          position: 1,
          tag: 'none',
          description: item[:snippet][:description],
          text_content: item[:snippet][:description],
          video_url: youtube_url_generator(item[:id][:videoId]),
          image_url: item[:snippet][:thumbnails][:high][:url],
          count_like: 0,
          count_comment: 0,
          category_id: c.id,
          user_id: 1
        }

        Content.create!(creation_params)
      end
    end

    puts "FINISH SCRAPPING YOUTUBE DATA #{Time.now}"
  end
end

def youtube_url_generator(video_id)
  res_url = "https://www.youtube.com/watch?v=#{video_id}"
end

# 'channelId=UCGbshtvS9t-8CW11W7TooQg', = muse asia
# 'channelId=UCsXVk37bltHxD1rDPwtNM8Q', = kurzgesagt
