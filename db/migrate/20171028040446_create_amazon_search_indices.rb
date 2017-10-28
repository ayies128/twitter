class CreateAmazonSearchIndices < ActiveRecord::Migration[5.1]
  def change
    create_table :amazon_search_indices do |t|
      t.string :name
      t.timestamps
    end
  end
end
