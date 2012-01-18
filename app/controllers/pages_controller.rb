class PagesController < ApplicationController
  inherit_resources
  belongs_to :node, :shallow => true

  def destroy
    destroy! { eval("#{@page.parent.class.name.downcase}_path(#{@page.parent.id})") }
  end
end
