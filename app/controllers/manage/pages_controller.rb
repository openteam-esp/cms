class Manage::PagesController < Manage::ApplicationController
  inherit_resources
  belongs_to :node, :shallow => true

  def destroy
    destroy! { eval("manage_#{@page.parent.class.name.downcase}_path(#{@page.parent.id})") }
  end
end
