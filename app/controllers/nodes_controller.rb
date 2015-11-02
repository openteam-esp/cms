class NodesController < ApplicationController
  def show
    params_id = params[:id].force_encoding('iso-8859-1').encode!('utf-8')
    resource_id = params[:resource_id]
    @node = Node.find_by_route(params_id)

    unless @node
      arr_path =  params_id.split('/')
      resource_id = arr_path.pop
      params_id = arr_path.join('/')
      @node = Node.find_by_route(params_id)
    end

    render :file => "#{Rails.root}/public/404", :formats => [:html], :layout => false, :status => 404 and return unless @node

    @node.parts_params = params[:parts_params] || {}
    @node.parts_params.merge!(:page => params[:page])
    @node.resource_id = resource_id

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
