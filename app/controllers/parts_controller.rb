class PartsController < InheritedResources::Base
  belongs_to :page, :shallow => true
  actions :new, :create, :edit, :update, :destroy

end
