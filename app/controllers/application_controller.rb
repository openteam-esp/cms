class ApplicationController < ActionController::Base
  protect_from_forgery

  layout 'with_tree'

  respond_to :html, :json
end
