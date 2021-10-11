Rails.application.routes.draw do
  default_url_options host: ENV['app_host'], port: ENV['app_port']

  namespace :api, defaults: { format: :json } do
    resources :messages, only: [:show, :create]
  end
end
