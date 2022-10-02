PaypalPayment::Engine.routes.draw do
  get :/, to: 'payment#index', as: :start_payment

  post :create_payment, controller: :payment
  post :execute_payment, controller: :payment
end
