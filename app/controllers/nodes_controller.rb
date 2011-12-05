class NodesController < ApplicationController

  def show
    @node = Node.find_by_route(params[:id])
    @node.parts_params = params[:parts_params] || {}

    respond_to do |format|
      format.html
      format.json
    end
  end

  def treeview
    return if params[:root].empty?
    result = []
    nodes = params[:root].eql?('source') ? Site.all : Node.find(params[:root]).children
    nodes.each do | node |
      result << fill_node(node)
    end
    render :json => result, :layout => false
  end

  private

    def fill_node(node)
      hash = { 'text' => node.slug }
      hash.merge!({ 'id' => node.id.to_s }) if node.has_children?
      hash.merge!({ 'hasChildren' => true }) if node.has_children?
      hash
    end

end
