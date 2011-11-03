module ApplicationHelper

  def action_title(options={})
    controller = options[:controller] || params[:controller]
    action = options[:action] || params[:action]
    model  = "pluralize.#{controller.to_s.singularize}"
    action_conf = case action
      when 'show'
        return resource
      when 'create'
        { :action => 'new', :count => 1 }
      when 'update'
        { :action => 'edit', :count => 1 }
      when 'index'
        { :action => action, :count => 10 }
      else
        { :action => action, :count => 2 }
    end
    "#{I18n.t("actions.#{action_conf[:action]}")} #{I18n.t(model, :count => action_conf[:count])}"
  end

  def title
    action_title
  end

end
