class Manage::LocalesController < Manage::ApplicationController
  inherit_resources
  belongs_to :site, :shallow => true
  actions :new, :create, :update, :edit, :destroy, :show
end
