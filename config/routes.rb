Cms::Application.routes.draw do
  resources :parts

  resources :contents

  resources :regions

  resources :templates, :only => [:show, :edit, :update, :destroy]

  resources :pages

  resources :locales

  resources :sites do
    resources :templates, :only => [:index, :new, :create]
  end

  root :to => 'sites#index'

end
