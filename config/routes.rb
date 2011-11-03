Cms::Application.routes.draw do

  resources :parts

  resources :contents

  resources :regions

  resources :pages, :only => [:show, :edit, :update, :destroy]

  resources :locales do
    resources :pages, :only => [:index, :new, :create]
  end

  resources :templates, :only => [:show, :edit, :update, :destroy]

  resources :sites do
    resources :templates, :only => [:index, :new, :create]
  end

  root :to => 'sites#index'

end
