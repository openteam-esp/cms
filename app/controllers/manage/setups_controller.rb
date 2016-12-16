class Manage::SetupsController < Manage::ApplicationController
  layout 'application'

  inherit_resources
  belongs_to :site
  defaults singleton: true
  actions :show, :edit, :update

  def update
    update! do
      redirect_to manage_site_path(@site) and return
    end
  end
end
