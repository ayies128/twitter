class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	def initialize
		require 'twitter'
		@twitter = Twitter::REST::Client.new do |config|
			# applicationの設定
			config.consumer_key         = "Jfey9EMMkeR13BdDV6D4QOydp"
			config.consumer_secret      = "7qdSs0TpBYyrLYLHZ34jQFSm2knIQ19lV6WciI574Ntf1aeDep"
			# ユーザー情報の設定
			config.access_token         = "4825740026-H77Ic5kpYPNdUPuGFbcor7DrYqNTKKOcygAmayU"
			config.access_token_secret  = "B38VBDtWLq1O2okoewxrbnoFiUTYsCgQNxxAG1pRSB4oc"
  		end
	end

end
