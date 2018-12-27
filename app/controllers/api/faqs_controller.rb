module Api
  class FaqsController < ApplicationController
    def index
      categories = Rails.cache.fetch(CacheKeys::FAQ_CATEGORIES) do
        results = {}
        FaqCategory.all.each do |category|
          results[category.id] = category.name
        end
        results
      end

      faqs = Rails.cache.fetch(CacheKeys::FAQS) do
        results = []
        Faq.all.each do |faq|
          result = {
              category: categories[faq.faq_category_id],
              title: faq.title,
              content: faq.content
          }
          results << result
        end
        results
      end

      render json: faqs.to_json
    end
  end
end
