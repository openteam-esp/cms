class SitesController < ApplicationController
  inherit_resources

  layout 'application'

  def show
    show! do
      render :layout => 'with_tree' and return
    end
  end

end
