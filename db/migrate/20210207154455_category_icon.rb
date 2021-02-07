class CategoryIcon < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :fa_icon, :string
  end
end
