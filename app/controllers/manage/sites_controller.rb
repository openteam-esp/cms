class Manage::SitesController < Manage::ApplicationController
  inherit_resources

  layout 'application'

  def show
    show! do
      render :layout => 'with_tree' and return
    end
  end

  protected
    def collection
      @sites ||= Site.ordered
    end

end
