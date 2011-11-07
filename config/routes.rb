Cms::Application.routes.draw do

  resources :parts

  resources :contents

  resources :regions

  resources :parent_pages, :only => [] do
    resources :pages, :only => [:new, :create]
  end

  resources :pages

  resources :locales, :only => [:show, :edit, :update, :destroy]

  resources :templates, :only => [:show, :edit, :update, :destroy]

  resources :sites do
    resources :locales, :only => [:new, :create]
    resources :templates, :only => [:index, :new, :create]
  end

  root :to => 'sites#index'

end
