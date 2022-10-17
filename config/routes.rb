Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :responses
    end
  end
end
