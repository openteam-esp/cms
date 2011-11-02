module ApplicationHelper

  def title
    model  = "pluralize.#{params[:controller].singularize}"
    case params[:action]
    when 'index'
      "#{I18n.t('actions.index')} #{I18n.t(model, :count => 5)}"
    when 'show'
      resource
    when 'new', 'create'
      "#{I18n.t('actions.new')} #{I18n.t(model, :count => 2)}"
    when 'edit', 'update'
      "#{I18n.t('actions.edit')} #{I18n.t(model, :count => 2)}"
    end
  end

end
