class AddColumnKeyword < ActiveRecord::Migration[5.1]
  def change
    add_reference :search_words, :amazon_search_index, after: :word
  end
end
