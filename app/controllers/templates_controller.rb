class TemplatesController < InheritedResources::Base
  belongs_to :site, :shallow => true
end
