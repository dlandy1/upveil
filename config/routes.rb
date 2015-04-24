Upveil::Application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users, except: [:destroy, :index] do
    post '/follow' => 'users#follow', as: :follow
    get "/followers_list"  => 'users#followers_list', as: :followers_list
    get "/following_list"  => 'users#following_list', as: :following_list
    get 'followers'
    get 'following'
  end

  resources :categories, except: [:index] do
    post '/follow' => 'categories#follow', as: :follow
    post '/follow_male' => 'categories#male_follow', as: :male_follow
    post '/follow_female' => 'categories#female_follow', as: :female_follow
    get "subcategory_new"
    get "newest"
    get "male"
    get "female"
    get "male_newest"
    get "female_newest"
    resources :subcategories, only: [:index]
    resources :products, except: [:index], controller: 'categories/products' do
           post 'purchase'
    end
  end
  resources :products, except: [:show] do 
    post '/up-vote' => 'votes#up_vote', as: :up_vote
    post '/down-vote' => 'votes#down_vote', as: :down_vote
    resources :comments, only: [:create, :destroy, :edit, :update] do
         get "/reply"  => 'comments#reply', as: :reply
         get "/cancel"  => 'comments#cancel', as: :cancel
       end
  end
  resources :activities , :path => 'notifications'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

    match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

   root to: 'products#index'

   get "products/newest"
   get 'application/notifications'
   get 'application/close'  => 'application#close', as: :close
   get 'feed'  => 'feed#show', as: :feed
   post 'application/read_all_notification'
   get 'sitemap.xml', :to => 'sitemap#index', :defaults => { :format => 'xml' }




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
  #       product 'toggle'
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
  #     product 'toggle'
  #   end
  #   resources :products, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
