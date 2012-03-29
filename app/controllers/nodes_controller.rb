class NodesController < ApplicationController
  def show
    @node = Node.find_by_route(params[:id])

    render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404 and return unless @node

    @node.parts_params = params[:parts_params] || {}
    @node.resource_id = params[:resource_id]

    if params[:region]
      if @part = @node.part_for(params[:region])
        render :json => @part.to_json
      else
        render :json => 'not found', :status => 404
      end

      return
    end

    respond_to do |format|
      format.html
      format.json { render :json => @node.to_json }
    end
  end
end
