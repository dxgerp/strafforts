class CreateFaqs < ActiveRecord::Migration[5.1]
  def change
    create_table :faqs do |t|
      t.integer :faq_category_id
      t.text :title
      t.text :content

      t.timestamps
    end
  end
end
