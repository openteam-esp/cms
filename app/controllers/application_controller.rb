class ApplicationController < ActionController::Base
  inherit_resources

  protect_from_forgery

  layout 'common'

  respond_to :html, :json
end
