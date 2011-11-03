class PagesController < InheritedResources::Base
  belongs_to :site, :shallow => true do
    belongs_to :locale, :shallow => true
  end
end
