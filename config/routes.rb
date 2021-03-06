Cms::Application.routes.draw do
  mount ElVfsClient::Engine => '/'
  mount API => '/'

  match "/build_info_path" => 'service#build_info_path'

  namespace :manage do
    resources :nodes, :only => [] do
      resources :pages, :only => [:new, :create]
      resources :parts, :only => [:new, :create]

      match 'sort',   :on => :collection, :via => :post
      match 'search', :on => :collection, :via => :post
    end

    match '/treeview' => 'nodes#treeview', :via => :get

    resources :sites do
      resources :locales, :only => [:new, :create]
      resources :locale_associations, :only => [:new, :create, :destroy]
      resource :setup, only: [:show, :edit, :update]
    end

    resources :locales,            :only => [:show, :edit, :update, :destroy]
    resources :pages,              :only => [:show, :edit, :update, :destroy]
    resources :parts,              :only => [:edit, :update, :destroy]

    get 'spotlight' => 'spotlight#proxy'

    root :to => 'sites#index'
  end

  get '/nodes/*id/-/*resource_id', :to => "nodes#show", :format => true
  get '/nodes/*id', :to => "nodes#show", :format => true

  root :to => 'home#index'
end
