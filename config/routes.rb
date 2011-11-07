Cms::Application.routes.draw do

  resources :parts

  resources :contents

  resources :regions

  resources :node, :only => [] do
    resources :pages, :only => [:new, :create]
  end

  resources :pages, :only => [:show, :edit, :update, :destroy]

  resources :locales, :only => [:show, :edit, :update, :destroy]

  resources :templates, :only => [:show, :edit, :update, :destroy]

  resources :sites do
    resources :locales, :only => [:new, :create]
    resources :templates, :only => [:index, :new, :create]
  end

  root :to => 'sites#index'

end
