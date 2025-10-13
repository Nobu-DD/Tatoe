Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  devise_scope :user do
    get "users/edit_password", to: "users/registrations#edit_password"
    patch "users/update_password", to: "users/registrations#update_password"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :topics, only: %i[index new create show edit update destroy] do
    post :generate_ai, on: :collection
    get :ogp_image, on: :member, to: "ogp_images#show_topic"
    resources :answers, only: %i[new show create edit update destroy] do
      post :generate_ai, on: :collection
      get :ogp_image, on: :member, to: "ogp_images#show_answer"
      resource :answer_reactions, only: %i[create destroy]
      resources :comments, only: %i[show edit create update destroy]
    end
  end
  resource :mypage, only: %i[show update destroy]
  resource :likes, only: %i[create destroy]

  # get "images", on: :member, to: "images#ogp"
  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "top#index"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
