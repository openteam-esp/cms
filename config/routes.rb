Cms::Application.routes.draw do

  resources :parts, :only => [:edit, :update, :destroy]

  resources :contents

  resources :uploads, :only => [:new, :create, :index, :destroy]

  resources :nodes, :only => [] do
    resources :pages, :only => [:new, :create]
    resources :parts, :only => [:new, :create]
    match 'sort', :on => :collection, :via => :post
    match 'search', :on => :collection, :via => :post
  end

  match '/treeview' => 'nodes#treeview', :via => :get

  resources :pages, :only => [:show, :edit, :update, :destroy]

  resources :locales, :only => [:show, :edit, :update, :destroy]

  resources :sites do
    resources :locales, :only => [:new, :create]
  end

  root :to => 'sites#index'

  get '/nodes/(*id)', :to => "nodes#show", :format => true

  mount ElVfsClient::Engine => '/'
  match "/build_info_path" => 'service#build_info_path'
end
