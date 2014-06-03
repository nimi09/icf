Icf::Application.routes.draw do
  
  get "feedbacks/new"

#  get "revenues/new"
#  get "workinghours/new"
#  get "rentals/new"
#  get "expenses/new"
#  get "projects/new"
#  get "projects/show"

  resources :feedbacks do

    collection do
      get 'newestfirst'
      get 'byvotes'
    end

    member do #with feedback :id
      match '/up',    to: 'feedbacks#voteup',   via: 'post'
      match '/down',  to: 'feedbacks#votedown', via: 'post'
      match '/implemented', to: 'feedbacks#implemented', via: 'get'
    end
  end

  resources :revenues
  resources :workinghours
  resources :rentals
  resources :expenses

  resources :projects do
#    collection do # WITHOUT project :id
#      get 'invite'
#    end
    member do # with project :id
      get  'status'
      get  'addcrewmember'
      post 'assign_invited_user'
#      match 'assign_invited_user/:email', to: 'projects#assign_invited_user', via: 'post'
      get 'all_crew_members'

      match '/member/:uid',               to: 'projects#crew_member',         via: 'get'
      match '/member/:uid/expenses',      to: 'projects#member_expenses',     via: 'get'
      match '/member/:uid/rentals',       to: 'projects#member_rentals',      via: 'get'
      match '/member/:uid/workinghours',  to: 'projects#member_workinghours', via: 'get'
      match '/member/:uid/revenues',      to: 'projects#member_revenues',     via: 'get'
    end
  end

  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  root to: 'static_pages#home'

  match '/signup', to: 'users#new',        via: 'get'
  match '/login',  to: 'sessions#new',     via: 'get'
  match '/logout', to: 'sessions#destroy', via: 'delete'

  match '/contact', to: 'static_pages#contact', via: 'get'

  match '/display_row_count', to: 'static_pages#display_row_count', via: 'get'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
