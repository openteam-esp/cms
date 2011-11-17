class NodesController < ApplicationController
  def show
    @node = Node.find_by_route(route)
    @node.parts_params = parts_params

    respond_to do |format|
      format.html
      format.json
    end
  end

  private
    def route
      params[:id].split('?').first
    end

    def parts_params
      params[:id].split('?').last
    end
end
