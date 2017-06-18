class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	def initialize
		require 'twitter'
		@twitter = Twitter::REST::Client.new do |config|
			# applicationの設定
			config.consumer_key         = "ダミー"
			config.consumer_secret      = "ダミー"
			# ユーザー情報の設定
			config.access_token         = "ダミー"
			config.access_token_secret  = "ダミー"
  		end
	end

end
