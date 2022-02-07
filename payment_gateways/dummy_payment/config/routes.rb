DummyPayment::Engine.routes.draw do
  get :/, to: 'payment#index', as: :start_payment

  post :pay, to: 'payment#complete_payment', as: :complete_payment
end
