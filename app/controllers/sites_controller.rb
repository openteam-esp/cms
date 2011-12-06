class SitesController < ApplicationController

  layout 'application'

  def show
    show! do
      render :layout => 'common' and return
    end
  end

end
