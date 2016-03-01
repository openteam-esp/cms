class Manage::PartsController < Manage::ApplicationController
  inherit_resources
  belongs_to :node, :shallow => true
  actions :new, :create, :edit, :update, :destroy

  layout 'application'

  protected
    def build_resource
      part_type = params[:part][:type]
      if Part.descendants.map(&:to_s).include?(part_type)
        @part = part_type.constantize.new(params[:part])
        @part.node = parent
        @part
      else
        flash[:error] = "Не выбран тип для региона #{params['part']['region']}!"
        redirect_to smart_resource_url and return
        raise "Cann't constantize #{params[:part][:type].inspect}"
      end
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
