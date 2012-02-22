class NodesController < ApplicationController
  def show
    @node = Node.find_by_route(params[:id])

    render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404 and return unless @node

    @node.parts_params = params[:parts_params] || {}
    @node.resource_id = params[:resource_id]

    respond_to do |format|
      format.html
      format.json { render :json => @node.to_json }
    end
  end
end
