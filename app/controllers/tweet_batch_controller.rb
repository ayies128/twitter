class TweetBatchController < ApplicationController

	def afiri
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
				res = Amazon::Ecs.item_search(
					SearchWord.all.shuffle.first.word, 
					{
						search_index: AmazonSearchIndex.all.shuffle.first.name, 
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

  end
