JobBoardv2::Application.routes.draw do
  
  root :to => 'jobs#index'
  
  match '/media(/:dragonfly)', :to => Dragonfly[:images]
  
  namespace :admin do
    resources :jobs
  end

end
