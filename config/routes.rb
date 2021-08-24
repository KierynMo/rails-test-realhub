Rails.application.routes.draw do
  root to: "orders#index"

  get '/', to: "orders#index"
  post '/update-status', to: 'orders#update_status'
  get '/artwork/:id', to: 'orders#order_artwork', as: 'artwork'
end
