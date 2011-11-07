class PagesController < InheritedResources::Base
  belongs_to :site, :shallow => true #, :polymorphic => true
  #do
    #belongs_to :parent_page, :class_name => 'Page', :optional => true
  #end


end
