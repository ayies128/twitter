Rails.application.routes.draw do
  get 'search_word/list'
  get 'search_word/add'
  get 'search_word/del'

  get 'tweet_batch/afiri'
  get 'tweet_batch/fashion_afiri'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
