class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	def initialize
		require 'twitter'
		twitter_account = TwitterAccount.find(1)
		@twitter = Twitter::REST::Client.new do |config|
			# applicationの設定
			config.consumer_key         = twitter_account.consumer_key
			config.consumer_secret      = twitter_account.consumer_secret
			# ユーザー情報の設定
			config.access_token         = twitter_account.access_token
			config.access_token_secret  = twitter_account.access_token_secret
  		end
	end

end
