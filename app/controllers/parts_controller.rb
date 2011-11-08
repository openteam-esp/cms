class PartsController < ApplicationController
  belongs_to :node, :shallow => true
  actions :new, :create, :edit, :update, :destroy

  protected
    def build_resource
      region = params[:region]
      part_class = "#{parent.template_regions[region].capitalize}Part".constantize
      @part = part_class.new(params[part_class.name.underscore])
      @part.region = region
      @part.page = parent
      @part
    end

    def resource_params
      [params[@part.class.name.underscore] || {}]
    end

    def smart_resource_url
      parent
    end
end
