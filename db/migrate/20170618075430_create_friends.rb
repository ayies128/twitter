class CreateFriends < ActiveRecord::Migration[5.1]
	def change
		create_table :friends, :options => 'ENGINE=InnoDB CHARSET=utf8 COMMENT="フォローリスト"' do |t|
			t.string :friend_id, limit: 127, null: false
			t.column :created_at, 'DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP'
			t.column :updated_at, 'TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'
		end
	end
end
