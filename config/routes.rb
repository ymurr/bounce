Rails.application.routes.draw do
  resources :budgets
  #resources :products

  root "products#index"
  resources :products do
  #  collection { post :import }
  end


  resources :product_imports
  resources :budget_imports


  resources :budgets do
 #   collection { post :import }
 end
end
