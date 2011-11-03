module ApplicationHelper

  def title
    action_title
  end

  def pluralized_model(controller_name = params[:controller])
    "pluralize.#{controller_name.to_s.singularize}"
  end

  def action_title(options={})
    controller_name = options[:controller] || params[:controller]
    action = options[:action] || params[:action]
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
    "#{I18n.t("actions.#{action_conf[:action]}")} #{I18n.t(pluralized_model(controller_name), :count => action_conf[:count])}"
  end

end
