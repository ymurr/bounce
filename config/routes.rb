Rails.application.routes.draw do
  #resources :products

  root "products#index"

  resources :products do
    collection { post :import }
  end
end
