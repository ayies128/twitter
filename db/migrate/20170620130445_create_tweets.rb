class CreateTweets < ActiveRecord::Migration[5.1]
	def change
		create_table :tweets, :options => 'ENGINE=InnoDB CHARSET=utf8' do |t|
			t.text :contents
			t.column :created_at, 'DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP'
			t.column :updated_at, 'TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'
		end
	end
end
