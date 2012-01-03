Psychtest::Application.routes.draw do
  resources :users

  namespace :admin do
    root :to => "admin#index"    
      
    resources :questions, :only =>[ :index, :new, :create, :edit, :update, :destroy ] do            
      member do
        get 'keywords_wizard_select_new'
        post 'keywords_wizard_update_new'
        get 'keywords_wizard_synonyms_select_new'
        put 'keywords_wizard_synonyms_select_update_new'
        
        get 'keywords_new'
        post 'keywords_create'
        
        get 'edit_keyword'
        put 'update_keyword'
        delete 'destroy_keyword'        
      end      
    end
    
    resources :study_users, :only => [ :index, :new, :create, :destroy, :edit, :update ] do
      
    end
    
    resources :test_meta, :only => [] do
      collection do
        post 'advance_to_next_week'
        post 'revert_to_last_week'
        post 'update_week_count'
      end
    end
    
    resources :responses, :only => [] do
      collection do
        get 'dump'
        get 'clear_all'
      end
    end
  end
  
  resources :test, :only => [] do
    collection do
      get 'home'
      post 'sign_in'
      get 'welcome'
      get 'sign_out'
      get 'finished'
      
      get 'step'
      post 'complete_step'      
    end
  end
  
  root :to => "test#home"
  
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
