require 'digest'

namespace :scrapper do
  # exec sample: bin/rake 'scrapper:youtube'
  desc 'scrap youtube data'
  task :youtube => :environment do |_task, args|
    puts "START SCRAPPING YOUTUBE DATA #{Time.now}"

    title = 'live hacks'

    c = Category.find_by(title: title)
    if c.present?
      puts "CATEGORY #{title} ALREADY EXISTS"
    else
      c = Category.create(category_type: 'default', title: title, position: '7', tag: 'none', feed_id: Feed.first.id)
      puts "CREATED NEW CATEGORY #{title}"
    end

    items = []
    nextPageToken = nil
    host = 'https://www.googleapis.com/youtube/v3/search?'

    for i in 1..1 do
      params = [
        'key=AIzaSyDL9jzmqn7zo2EDs0LGT82wu3_sQykZqaE',
        'channelId=UC295-Dw_tDNtZXFeAPAW6Aw',
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
          user_id: 13
        }

        content = Content.find_by(title: creation_params[:title])
        if content
          puts "CONTENT #{creation_params[:title]} ALREADY EXISTS"
        else
          puts "ITEM DATA: #{creation_params}"
          Content.create!(creation_params)
          puts "CREATED NEW CONTENT #{creation_params[:title]}"
        end
      end
    end

    puts "FINISH SCRAPPING YOUTUBE DATA #{Time.now}"
  end

  # exec sample: bin/rake 'scrapper:youtube["live hacks", 13, "UCGbshtvS9t-8CW11W7TooQg"]'
  desc 'scrap youtube data'
  task :youtube_v2, %i[category_title user_id channel_id] => :environment do |_task, args|
    puts "START SCRAPPING YOUTUBE DATA #{Time.now}"

    title = 'live hacks'

    c = Category.find_by(title: args.category_title)
    if c.present?
      puts "CATEGORY #{title} ALREADY EXISTS"
    else
      c = Category.create(category_type: 'default', title: title, position: '7', tag: 'none', feed_id: Feed.first.id)
      puts "CREATED NEW CATEGORY #{title}"
    end

    items = []
    nextPageToken = nil
    host = 'https://www.googleapis.com/youtube/v3/search?'

    for i in 1..1 do
      params = [
        'key=AIzaSyDL9jzmqn7zo2EDs0LGT82wu3_sQykZqaE',
        "channelId=#{args.channel_id}",
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
          user_id: args.user_id
        }

        content = Content.find_by(title: creation_params[:title])
        if content
          puts "CONTENT #{creation_params[:title]} ALREADY EXISTS"
        else
          puts "ITEM DATA: #{creation_params}"
          Content.create!(creation_params)
          puts "CREATED NEW CONTENT #{creation_params[:title]}"
        end
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
# 'channelId=UCb8vrqP8Z7Oz9ZTYvUtjUHQ', = daniel labelle
# 'channelId=UC1dI4tO13ApuSX0QeX8pHng', = gadgedin
# 'channelId=UC295-Dw_tDNtZXFeAPAW6Aw', = 5-minutes-craft