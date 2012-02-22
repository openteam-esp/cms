class Manage::PartsController < Manage::ApplicationController
  inherit_resources
  belongs_to :node, :shallow => true
  actions :new, :create, :edit, :update, :destroy

  layout 'application'

  protected
    def build_resource
      part_class = params[:part][:type].constantize
      @part = part_class.new(params[:part])
      @part.node = parent
      @part
    end

    def resource_params
      [params[@part.class.name.underscore] || {}]
    end

    def smart_resource_url
      [:manage, parent]
    end

    def smart_collection_url
      [:manage, parent]
    end
end
