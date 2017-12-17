class TweetBatchController < ApplicationController

	def afiri
		twitter_account = TwitterAccount.find(1)
		@twitter = Twitter::REST::Client.new do |config|
			# applicationの設定
			config.consumer_key         = twitter_account.consumer_key
			config.consumer_secret      = twitter_account.consumer_secret
			# ユーザー情報の設定
			config.access_token         = twitter_account.access_token
			config.access_token_secret  = twitter_account.access_token_secret
		end

		# Amazon Product Advertising API へのアクセスに必要なキーを設定
		paapi_account = PaapiAccount.find(1)
		Amazon::Ecs.configure do |options|
			options[:associate_tag] = paapi_account.associate_tag
			options[:AWS_access_key_id] = paapi_account.access_key_id
			options[:AWS_secret_key] = paapi_account.secret_key
		end

		loop_count = 1
		res = nil
		loop do
			begin
				amazon_search_index = AmazonSearchIndex.all.shuffle.first
				res = Amazon::Ecs.item_search(
					amazon_search_index.search_words.shuffle.first.word, 
					{
						search_index: amazon_search_index.name, 
						response_group: 'ItemAttributes,Offers',
						item_page: 1, 
						country: 'jp', 
						sort: 'salesrank'
					}
				)
				break
			rescue => e
				loop_count += 1
				break if loop_count > 10
				sleep(11)
				next
			end
		end
		if res.present?
			item = res.items.shuffle.first
			title = item.get('ItemAttributes/Title')
			manufacturer = item.get('ItemAttributes/Manufacturer')
			url = item.get('DetailPageURL')
			lowest_price = item.get('OfferSummary/LowestNewPrice/FormattedPrice')
			if title.present? && manufacturer.present? && url.present? && lowest_price.present?
				tweet = "Amazonで人気の商品をご紹介٩( 'ω' )\r#{manufacturer}の『#{title}』\r今なら最安値は#{lowest_price}\r#{url}"
			else
				tweet = Tweet.all.shuffle.first.contents
			end
		else
			tweet = Tweet.all.shuffle.first.contents
		end
		@twitter.update(tweet)
	end

	def fashion_afiri
		twitter_account = TwitterAccount.find(2)
		@twitter = Twitter::REST::Client.new do |config|
			# applicationの設定
			config.consumer_key         = twitter_account.consumer_key
			config.consumer_secret      = twitter_account.consumer_secret
			# ユーザー情報の設定
			config.access_token         = twitter_account.access_token
			config.access_token_secret  = twitter_account.access_token_secret
		end

		# Amazon Product Advertising API へのアクセスに必要なキーを設定
		paapi_account = PaapiAccount.find(1)
		Amazon::Ecs.configure do |options|
			options[:associate_tag] = paapi_account.associate_tag
			options[:AWS_access_key_id] = paapi_account.access_key_id
			options[:AWS_secret_key] = paapi_account.secret_key
		end

		loop_count = 1
		res = nil
		loop do
			begin
				amazon_search_index = AmazonSearchIndex.find(1)
				res = Amazon::Ecs.item_search(
					amazon_search_index.search_words.shuffle.first.word, 
					{
						search_index: amazon_search_index.name, 
						response_group: 'ItemAttributes,Offers',
						item_page: 1, 
						country: 'jp', 
						sort: 'salesrank'
					}
				)
				break
			rescue => e
				loop_count += 1
				break if loop_count > 10
				sleep(11)
				next
			end
		end
		if res.present?
			item = res.items.shuffle.first
			title = item.get('ItemAttributes/Title')
			manufacturer = item.get('ItemAttributes/Manufacturer')
			url = item.get('DetailPageURL')
			lowest_price = item.get('OfferSummary/LowestNewPrice/FormattedPrice')
			if title.present? && manufacturer.present? && url.present? && lowest_price.present?
				tweet = "Amazonで人気の商品をご紹介٩( 'ω' )\r#{manufacturer}の『#{title}』\r今なら最安値は#{lowest_price}\r#{url}"
			else
				tweet = Tweet.all.shuffle.first.contents
			end
		else
			tweet = Tweet.all.shuffle.first.contents
		end
		@twitter.update(tweet)
		render json: {'success': => true}
	end

  end
