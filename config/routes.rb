Rails.application.routes.draw do
  get '/health-check', to: 'application#health_check', as: :health_check
end
