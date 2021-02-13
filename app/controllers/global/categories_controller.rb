module Global
  class CategoriesController < ApiController
    def index
      categories = Category.all
      render_response(data: serialize_categories(categories))
    end

    private

    def serialize_categories(categories)
      categories.map do |category|
        {
          id: category.id,
          title: category.title,
          fa_icon: category.fa_icon
        }
      end
    end
  end
end
