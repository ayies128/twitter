# フォロー候補検索ワード設定
class SearchWordController < ApplicationController
	def list
		@serch_word_list = SearchWord.all
	end

	def add
		add_word = params[:add_word]
		if add_word.present?
			sw = SearchWord.new(word: add_word)
			sw.save
		end
		redirect_to action: "list"
	end

	def del
		del_id = params[:del_id]
		if del_id.present?
			sw = SearchWord.find(del_id)
			sw.destroy
		end
		redirect_to action: "list"
	end
end
