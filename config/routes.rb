Rails.application.routes.draw do
  namespace :api do
    get 'athletes/:id/meta' => 'meta#index'
    get 'athletes/:id/best-efforts' => 'best_efforts#index'
    get 'athletes/:id/best-efforts/:distance' => 'best_efforts#index'
    get 'athletes/:id/best-efforts/:distance/top-one-by-year' => 'best_efforts#top_one_by_year'
    get 'athletes/:id/personal-bests' => 'personal_bests#index'
    get 'athletes/:id/personal-bests/:distance' => 'personal_bests#index'
    get 'athletes/:id/races' => 'races#index'
    get 'athletes/:id/races/:distance_or_year' => 'races#index'

    post 'athletes/:id/submit-email' => 'athletes#submit_email' # set the email address that user has entered.
    post 'athletes/:id/fetch-latest' => 'athletes#fetch_latest'
    post 'athletes/:id/save-profile' => 'athletes#save_profile'
    post 'athletes/:id/reset-profile' => 'athletes#reset_profile'
    post 'athletes/:id/subscribe-to-pro' => 'athletes#subscribe_to_pro'

    get 'faqs/index' => 'faqs#index'
  end

  get 'athletes/:id' => 'athletes#index'
  get 'athletes/:id/confirm-your-email' => 'athletes#confirm_email' # the page that allows users to enter their email addresses.
  get 'athletes/:id/get-pro' => 'athletes#pro_plans'
  get 'athletes/:id/cancel-pro' => 'athletes#cancel_pro'

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  get 'errors/400' => 'errors#index'
  get 'errors/403' => 'errors#index'
  get 'errors/404' => 'errors#index'
  get 'errors/500' => 'errors#index'
  get 'errors/503' => 'errors#index'

  get 'home/index'

  get 'auth/exchange-token' => 'auth#exchange_token'
  get 'auth/deauthorize' => 'auth#deauthorize'
  get 'auth/logout' => 'auth#logout'
  get 'auth/verify-email/:token' => 'auth#verify_email_confirmation_token' # the page that takes in a token to verify the email.

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
end
