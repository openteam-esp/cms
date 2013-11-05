class Manage::SitesController < Manage::ApplicationController
  inherit_resources

  def index
    index! do
      render :layout => 'application' and return
    end
  end

end
