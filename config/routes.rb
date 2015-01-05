Rails.application.routes.draw do
  devise_for :users
  resources :users, :only => [:index] do
    member do
      resources :shifts    ,:only => [:index]
      get 'shifts/next_month' => 'shifts#next_month'
    end
  end
  resources :groups, :only => [:index] do
    member do
      resources :hosts, :except => [:destroy]
      resources :shifts    ,:only => [:new, :create, :index]
      patch 'decide' => 'hosts#decide'
      get 'acount_setting' => 'hosts#acount_setting'
      post 'acount_setting_decide' => 'hosts#acount_setting_decide'
    end
  end
  resources :groups, :only => [:new, :create]
  get 'search' => 'shifts#search'
  get '/dates/:date' => 'dates#show'
  delete '/dates/:date/:id' => 'dates#destroy'
  get '/dates/:date/add_shift/:time' => 'dates#add_shift'
  patch '/dates/:date/:id' => 'dates#add'
  get 'hosts/approval' => 'hosts#approval'
  patch 'hosts/user_add' => 'hosts#user_add'
  root :to => 'shifts#index'
end
