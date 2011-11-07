Cms::Application.routes.draw do

  resources :parts

  resources :contents

  resources :regions

  resources :parent_pages, :only => [] do
    resources :pages, :only => [:new, :create]
  end

  resources :pages

  resources :locales do
    #resources :pages, :only => [:index, :new, :create]
  end

  resources :templates, :only => [:show, :edit, :update, :destroy]

  resources :sites do
    resources :templates, :only => [:index, :new, :create]
    resources :pages, :only => [:index, :new, :create]
  end

  root :to => 'sites#index'

end
