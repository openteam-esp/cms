class ApplicationController < ActionController::Base
  inherit_resources

  protect_from_forgery

  layout 'with_tree'

  respond_to :html, :json
end
