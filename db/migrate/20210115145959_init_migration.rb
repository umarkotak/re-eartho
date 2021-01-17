# rails column data types https://github.com/rails/rails/blob/master/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L69
class InitMigration < ActiveRecord::Migration[6.1]
  def change

    create_table :users do |t|
      t.text :username
      t.text :email
      t.text :password_encrypted
      t.text :auth_token
      t.text :role
      t.text :status
      t.timestamps
    end

    create_table :feeds do |t|
      t.text :title
      t.timestamps
    end

    create_table :categories do |t|
      t.text :category_type
      t.text :title
      t.text :position
      t.text :tag
      t.integer :feed_id
      t.timestamps
    end

    create_table :contents do |t|
      t.text :content_type
      t.text :title
      t.text :position
      t.text :tag
      t.text :description
      t.text :text_content
      t.text :image_url
      t.text :video_url
      t.integer :count_like
      t.integer :count_comment
      t.integer :category_id
      t.integer :user_id
      t.timestamps
    end

    create_table :content_likes do |t|
      t.integer :content_id
      t.integer :user_id
      t.timestamps
    end

    create_table :content_comments do |t|
      t.text :comment
      t.integer :content_id
      t.integer :user_id
      t.timestamps
    end
  end
end
