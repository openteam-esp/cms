class LocalesController < InheritedResources::Base
  belongs_to :site, :shallow => true
  actions :new, :create, :update, :edit, :destroy, :show
end
