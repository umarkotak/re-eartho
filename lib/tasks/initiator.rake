require 'digest'

namespace :initiator do

  # exec sample: bin/rake 'initiator:generate_initial_data'
  desc 'generate initial data'
  task :generate_initial_data => :environment do |_task, args|
    puts "START GENERATING DATA #{Time.now}"

    # data users
    sha256_password = Digest::SHA2.hexdigest('123456')
    admin = User.create(username: 'admin', email: 'admin@admin.com', password_encrypted: sha256_password, role: 'admin', status: '1')
    user = User.create(username: 'user', email: 'user@user.com', password_encrypted: sha256_password, role: 'user', status: '1')
    user_red = User.create(username: 'user-red', email: 'user-red@user.com', password_encrypted: sha256_password, role: 'user', status: '1')

    # data feeds
    feed = Feed.create(title: 'default')

    # data categories
    category_1 = Category.create(category_type: 'default', title: 'fun', position: '1', tag: 'none', feed_id: feed.id)
    category_2 = Category.create(category_type: 'default', title: 'viral', position: '2', tag: 'none', feed_id: feed.id)
    category_3 = Category.create(category_type: 'default', title: 'motivating', position: '3', tag: 'none', feed_id: feed.id)
    category_4 = Category.create(category_type: 'default', title: 'live hacks', position: '4', tag: 'none', feed_id: feed.id)
    category_5 = Category.create(category_type: 'default', title: 'technology', position: '5', tag: 'none', feed_id: feed.id)

    # data contents
    categories = [category_1, category_2, category_3, category_4, category_5]
    categories.each do |c|
      (1..10).each do |idx|
        content = Content.create(
          content_type: 'default',
          title: "TITLE #{c.title} - #{idx}",
          position: idx,
          tag: 'none',
          description: 'DESCRIPTION, sometimes a bit longer than the other. Sometimes it is just what it is',
          image_url: 'https://i.picsum.photos/id/838/256/128.jpg?hmac=cCCGbyN8hEanN50YycbcOojsPDwHJg7XNG2vH5ZOXhM',
          video_url: 'https://www.youtube.com/watch?v=4b33NTAuF5E&ab_channel=Kurzgesagt%E2%80%93InaNutshell',
          count_like: idx,
          count_comment: idx,
          category_id: c.id,
          user_id: admin.id
        )
      end
    end

    # data content_likes

    # data content_comments

    puts "FINISH GENERATING DATA #{Time.now}"
  end

  # exec sample: bin/rake 'initiator:destroyer_run'
  desc 'destroy all data'
  task :destroyer_run => :environment do |_task, args|
    puts "START DESTROYING DATA #{Time.now}"

    ContentComment.all.delete_all
    ContentLike.all.delete_all
    Content.all.delete_all
    Category.all.delete_all
    Feed.all.delete_all
    User.all.delete_all

    puts "FINISH DESTROYING DATA #{Time.now}"
  end
end
