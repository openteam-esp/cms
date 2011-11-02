module ApplicationHelper

  def composed_title
    titles = []
    model  = "pluralize.#{params[:controller].singularize}"
    case params[:action]
    when 'index'
      titles << "#{I18n.t('actions.index')} #{I18n.t(model, :count => 5)}"
    when 'show'
      titles << resource
    when 'new', 'create'
      titles << "#{I18n.t('actions.new')} #{I18n.t(model, :count => 2)}"
    when 'edit', 'update'
      titles << "#{I18n.t('actions.edit')} #{I18n.t(model, :count => 2)}"
    end
    titles << I18n.t('application')
    titles.join(" | ")
  end

end
