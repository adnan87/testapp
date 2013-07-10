IJET::Application.routes.draw do
  #devise_for :users
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}
  #root :to => "home#index"
  root :to => "preview#index"
  
  resource :home, :controller => 'home', :path => '/'  do
    collection do
      get :admin
      get :featured
      get :thanks
      post :createfeatured
      get :viewcandidate
      post :verfiyemployer
      get :takeoff_landing
      get :employer
      post :createemployer
      get :viewprofile
      post :requestinterview
      get :review
      
      post :accept_interview_request
      post :decline_interview_request
      
      get :acceptrequest
      get :declinerequest
      get :verifycandidate
      get :validateemployer
    end
  end

  match 'viewcandidate/:id' => 'home#viewcandidate'
  match 'viewprofile/:id' => 'home#viewprofile'
  match 'review/:id' => 'home#review'
  
  resources :candidates  do
    collection do
      post :approve_candidate
      post :waitlist_candidate
      post :feature_candidate
      get :featured
      post :create_candidate
      get :takeoff_candidate
      get :sort_candidate
    end
  end

  resources :employerdomains do
    collection do
      get :sort_domain
    end
  end

  resources :employer_agreements do
    collection do

    end
  end
  
  resources :employers do
    collection do
      post :approve_employer
      post :waitlist_employer
      get :sort_employer
    end
  end

  resources :takeoffs do 
    collection do
      get :sort_takeoff
    end
  end

  resources :interviews do
    collection do
      post :processinterview
      post :approve_request
      post :decline_request
      get  :sort_interviews
    end
  end
  
  resources :agreements do
    collection do
      get :sort_agreement
    end
  end
  
  resources :reports

  resources :cmspage, :controller => 'cmspages'
  
  get "preview/index"
  get "preview/takeoff"
  get "preview/crewflew"
  post "preview/talent"
  post "preview/employerrequest"
  post "preview/requestinterview"
  get "preview/profile"
  get "preview/preview_profile"
  get "preview/employer"
  get "preview/viewtalent"
  get "preview/content"
  
  match 'preview' => 'preview#index'
  match 'preview/talent/:id' => 'preview#takeoff'
  match '/takeoff' => 'preview#takeoff'
  match '/crewflew' => 'preview#crewflew'
  match '/talent/:id' => 'preview#takeoff'
  match '/previewtakeoff/:id' => 'preview#preview_takeoff'
  
  match '/preview/viewtalent/:id' => 'preview#viewtalent'
  match '/:page' => 'preview#content'
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
#match ':controller(/:action(/:id))(.:format)'
end
