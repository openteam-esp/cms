class Manage::LocaleAssociationsController < Manage::ApplicationController
  layout 'application'
  inherit_resources
  belongs_to :site, :shallow => true
  actions :new, :create, :destroy

  def create
    create!{
      redirect_to  manage_site_path(@site) and return
    }
  end

  def destroy
    destroy!{
      redirect_to  manage_site_path(@site) and return
    }
  end
end
