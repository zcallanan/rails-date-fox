Rails.application.routes.draw do
  

  get 'activities/edit'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :experiences
  resources :searches, only: %i[new create edit update]
  get 'searches/:search_id/date_times/edit', to: 'date_times#edit', as: :date_times
  get 'searches/:search_id/activities/edit', to: 'activities#edit', as: :activities
  get 'searches/:search_id/price_ranges/edit', to: 'price_ranges#edit', as: :price_ranges
end
