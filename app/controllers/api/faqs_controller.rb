module Api
  class FaqsController < ApplicationController
    def index
      categories = {}
      FaqCategory.all.each do |category|
        categories[category.id] = category.name
      end

      results = []
      Faq.all.each do |faq|
        result = {
          category: categories[faq.faq_category_id],
          title: faq.title,
          content: faq.content
        }
        results << result
      end
      render json: results.to_json
    end
  end
end
