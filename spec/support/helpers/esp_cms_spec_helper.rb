module EspCmsSpecHelper
  def node(parent=root)
    @node ||= Fabricate(:node, :context => parent)
  end

  def another_node(parent=root)
    @another_node ||= Fabricate(:node, :context => parent)
  end
end
