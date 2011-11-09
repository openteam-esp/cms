Cms::Application.routes.draw do

  resources :parts, :only => [:edit, :update, :destroy]

  resources :contents

  resources :uploads, :only => [:new, :create, :index, :destroy]

  resources :node, :only => [] do
    resources :pages, :only => [:new, :create]
  end

  resources :pages, :only => [:show, :edit, :update, :destroy] do
    resources :parts, :only => [:new, :create]
    resources :html_parts, :only => [:new, :create]
  end

  resources :locales, :only => [:show, :edit, :update, :destroy]


  resources :sites do
    resources :locales, :only => [:new, :create]
  end


  get '/uploads/:id/:width-:height/*file_name' => Dragonfly[:uploads].endpoint { |params, app|
    image = Image.find(params[:id])
    width = [params[:width].to_i, image.file_width].min
    height = [params[:height].to_i, image.file_height].min
    image.file.thumb("#{width}x#{height}")
  }, :as => :image, :format => false

  get '/uploads/:id/cropped/*file_name' => Dragonfly[:uploads].endpoint { |params, app|
    image = Image.find(params[:id])
    image.file.thumb("100x100#")
  }, :as => :cropped_image, :format => false

  get '/uploads/:id/*file_name' => Dragonfly[:uploads].endpoint { |params, app|
    app.fetch(Upload.find(params[:id]).file_uid)
  }, :as => :upload, :format => false



  root :to => 'sites#index'

end
