class CreateSearchWords < ActiveRecord::Migration[5.1]
	def change
		create_table :search_words, :options => 'ENGINE=InnoDB CHARSET=utf8 COMMENT="フォロー候補検索ワード"' do |t|
			t.string :word, limit: 127, null: false
			t.column :created_at, 'DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP'
			t.column :updated_at, 'TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'
		end
	end
end
