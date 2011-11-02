Cms::Application.routes.draw do
  resources :parts

  resources :contents

  resources :regions

  resources :templates

  resources :pages

  resources :locales

  resources :sites

  root :to => 'sites#index'

end
