HelpMeText::Application.routes.draw do

  get "/experts/expert/:expertID" => 'experts#show'
  get "/experts/list/:specialty" => 'experts#list'
  put "/experts/expert/availability" => 'experts#updateAvailability'
  get "/experts/new" => 'experts#newExpert'
  post "/experts/create" => 'experts#createExpert'
  get "/experts/pay/:expertID" => 'experts#payExpert'
  post "/experts/pay/:expertID" => 'experts#submitPayment'
  get "/experts/all" => 'experts#all'

  post "/users/signup" => 'users#signup'
  post "/users/signin" => 'users#signin'
  post "/users/buy" => 'users#purchaseCorrespondence'
  get "/users/" => 'users#getUsers'
  get "/users/user/qb/:qbID" => 'users#getQBUser'
  get "/users/user/:id" => 'users#getUser'
  
  get "/articles/" => 'articles_api#get_all_articles'
  get "/articles/article/:articleID" => 'articles_api#get_article'
  post "/articles/create" => 'articles_api#create'
  get "/articles/new" => 'articles_api#new'

  post "/chats/end-chat" => 'chats#endChat'
  post "/chats/new" => 'chats#new'
  put "/chats/submit-rating" => 'chats#submitRating'
  get "/chats/user/active/:userID" => 'chats#userActiveChats'
  get "/chats/expert/active/:expertID" => 'chats#expertActiveChats'
  get "/chats/dialog/chat/:dialogID" => 'chats#getChatWithDialog'
  post "/chats/dialog" => 'chats#addDialogId'
  get "/chats/unrated/:userID" => 'chats#unratedInactiveChats'
  put "/chats/renew/request" => 'chats#renewChatRequest'
  put "/chats/renew" => 'chats#renewChat'



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
