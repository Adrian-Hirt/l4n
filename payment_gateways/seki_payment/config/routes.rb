SekiPayment::Engine.routes.draw do
  get :/, to: 'payment#index', as: :start_payment

  post :submit_order, to: 'payment#submit_order_for_delayed_payment', as: :submit_order
end
