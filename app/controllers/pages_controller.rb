class PagesController < InheritedResources::Base
  belongs_to :node, :shallow => true
end
