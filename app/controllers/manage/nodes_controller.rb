class Manage::NodesController < Manage::ApplicationController
  def search
    node = Node.find_by_route(params[:change_route][:site_slug] + params[:change_route][:route])

    redirect_to [:manage, node] and return if node

    redirect_to :back
  end

  def sort
    params[:ids].each_with_index do |id, index|
      node = Node.find(id)
      node.update_attribute(:navigation_position, index + 1)
    end

    render :nothing => true
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
      hash = { 'text' => "<a href='/manage/#{node.class.name.tableize}/#{node.id}'>#{node.slug}</a>" }
      hash.merge!({ 'id' => node.id.to_s, 'hasChildren' => true }) if node.has_children?
      hash
    end
end
