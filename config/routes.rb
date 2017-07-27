Rails.application.routes.draw do
  root 'organizations#index'

  get '/user_protocols', to: 'user_protocols#index', as: :protocols
  delete '/user_protocols', to: 'user_protocols#destroy_all', as: :protocols_destroy_all

  get 'dj_manager/index', as: :dj_index
  get 'dj_manager/:id' => "dj_manager#show", as: :dj_show


  post 'dj_manager/create_planner' => "dj_manager#create_planner", as: :dj_create_planner
  delete 'dj_manager/:id/destroy' => "dj_manager#destroy", as: :dj_delete
  delete 'dj_manager/destroy_all', as: :dj_delete_all

  resources :option_sets
  resources :services do
    collection do
      get 'datatable' # pagination
    end
    member do
      get 'legalise'
      get 'unlegalise'
    end
  end
  resources :jobs do
    member do
      get 'scan'
    end
  end
  resources :schedules
  resources :users
  resources :scanned_ports do
    collection do
      get 'datatable' # pagination
    end
  end
  resources :organizations do
    member do
      post 'report'
    end
  end

  resources :user_sessions, only: [:create, :destroy]

  delete '/sign_out', to: 'user_sessions#destroy', as: :sign_out
  get '/sign_in', to: 'user_sessions#new', as: :sign_in

  resource :users_roles

  get '/service_tasks', to: 'service_tasks#index', as: :service_tasks
  post '/service_tasks/clean_base', to: 'service_tasks#clean_base', as: :clean_base_task
  post '/service_tasks/sqlite_backup', to: 'service_tasks#sqlite_backup', as: :sqlite_backup_task

  get '/detected_services', to: 'dashboard#detected_services', as: :detected_services
  get '/dashboard/datatable', to: 'dashboard#datatable'
  get '/dashboard/datatable2', to: 'dashboard#datatable2'
  get '/new_services', to: 'dashboard#new_services', as: :new_services
  get '/hosts', to: 'dashboard#hosts', as: :hosts

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
