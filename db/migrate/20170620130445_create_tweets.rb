class CreateTweets < ActiveRecord::Migration[5.1]
	def change
		create_table :tweets do |t|
			t.text :contents
			t.timestamps
		end
	end
end
