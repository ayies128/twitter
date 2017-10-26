class TweetBatchController < ApplicationController
	@@my_twitter_id = 4825740026

	# 定期的にフォローするバッチ
	def follow
		take_count = params[:count]
		return if take_count.blank?

		my_info = @twitter.user(@@my_twitter_id)
		if my_info.followers_count.to_f * 1.1 - take_count.to_f <= my_info.friends_count.to_f then
			unfollow_list = []
			Friend.order("created_at DESC").limit(take_count.to_i).each do |friend|
				unfollow_list << friend.friend_id.to_i
			end
			@twitter.unfollow(unfollow_list) if unfollow_list.present?
		end
		# 参照：http://qiita.com/riocampos/items/6999a52460dd7df941ea
		# フォローするユーザーIDリスト：DB用
		save_list = []
		search_word = SearchWord.all.shuffle.first.word
		@twitter.search(search_word, lang: "ja", count: take_count.to_i).take(50).each do |tweet|
			puts Friend.where(friend_id: tweet.user.id).count
			if Friend.where(friend_id: tweet.user.id).count == 0 then
				# ブロックされていたらエラーになるので一括フォローはきつい
				begin
					@twitter.follow(tweet.user.id)
					save_list << Friend.new(friend_id: tweet.user.id)
				rescue => e
					puts "#{e.class}：#{tweet.user.name}"
					if e.class.to_s == "Twitter::Error::TooManyRequests"
						break
					else 
						next
					end
				end
			end
			puts "save_count：#{save_list.count}"
			break if save_list.count >= take_count.to_i
		end
		Friend.import save_list
	end

	def afiri
		begin
			# Amazon Product Advertising API へのアクセスに必要なキーを設定
			Amazon::Ecs.configure do |options|
				options[:associate_tag] = "kabk128-22"
				options[:AWS_access_key_id] = "AKIAIXSIY7KHU6TC2D7A"
				options[:AWS_secret_key] = "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"
			end
			keywords = ['健康', 'ファッション', '漫画', 'おもちゃ', 'レディース', 'フィギュア', 'ドラマ', 'PC', 'スマホ', 'メンズ', '筋トレ', '酒', '時計']
			search_index = ['Apparel','Automotive','Baby','Beauty','Books','Classical','DVD','Electronics','ForeignBooks','Grocery','HealthPersonalCare','Hobbies','HomeImprovement','Jewelry','Kitchen','Music','MusicTracks','OfficeProducts','Shoes','Software','SportingGoods','Toys','VHS','Video','VideoGames','Watches']
			res = Amazon::Ecs.item_search(keywords.shuffle.first, {search_index: search_index.shuffle.first, item_page: 1, country: 'jp', sort: 'salesrank'})
			item = res.items.shuffle.first
			tweet = "今Amazonで人気の商品をご紹介＾＾\r「#{item.get("ItemAttributes/Title")}」\r#{item.get('DetailPageURL')}"
		rescue => e
			tweet = Tweet.all.shuffle.first.contents
		end
		@twitter.update(tweet)
	end

  	# フォローしているユーザーをリセット
  	def friend_reset
  		# 登録リスト
  		save_list = []
  		@twitter.friend_ids(@@my_twitter_id).each do |friend_id|
  			save_list << Friend.new(friend_id: friend_id)
  		end
  		# テーブル全削除
                Friend.destroy_all
		Friend.import save_list
  	end

  end
