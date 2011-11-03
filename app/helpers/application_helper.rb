module ApplicationHelper

  def action_title(controller = params[:controller], action = params[:action])
    model  = "pluralize.#{controller.singularize}"
    action = case action
    when 'show'
      return resource
    when 'create'
      'new'
    when 'update'
      'edit'
    else
      action
    end
    "#{I18n.t("actions.#{action}")} #{I18n.t(model, :count => 2)}"
  end

  def title
    action_title
  end

end
