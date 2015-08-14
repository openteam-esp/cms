class Manage::SitesController < Manage::ApplicationController
  inherit_resources

  layout 'application'

  def show
    show! do
      render :layout => 'with_tree' and return
    end
  end

  def destroy
    parent = resource.parent

    destroy! {
      redirect_to parent
    }
  end

  protected

    def collection
      @sites ||= Site.ordered
    end
end
