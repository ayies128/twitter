class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	def initialize
		require 'twitter'
		@twitter = Twitter::REST::Client.new do |config|
			# applicationの設定
			config.consumer_key         = "PKgfxczzfKnpdW7PbgolLDND6"
			config.consumer_secret      = "Xjdma9TXANkqGDFNdPLXG9Ecxelgo295x6KrFXkTM3SvaKMPi2"
			# ユーザー情報の設定
			config.access_token         = "4825740026-PTfJtQxbtDr763XeWzsZqL02mglX2TccLa5mT7D"
			config.access_token_secret  = "PtHhG9fTviN06czCcvaSUovOGJK92Tr0XsealkKNiP1fr"
  		end
	end

end
