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
		@twitter.update(Tweet.all.shuffle.first.contents)
	end

	def everyday
	end

  	# フォローしているユーザーをリセット
  	def friend_reset
  		# テーブル全削除
  		Friend.destroy_all
  		# 登録リスト
  		save_list = []
  		@twitter.friend_ids(@@my_twitter_id).each do |friend_id|
  			save_list << Friend.new(friend_id: friend_id)
  		end
  		Friend.import save_list
  	end

  end
