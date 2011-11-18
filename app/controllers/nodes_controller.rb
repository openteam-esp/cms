class NodesController < ApplicationController
  def show
    @node = Node.find_by_route(params[:id])
    @node.parts_params = params[:parts_params] || {}

    respond_to do |format|
      format.html
      format.json
    end
  end
end
