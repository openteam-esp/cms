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

  def expanded_ancestors(ancestors)
    result = ""
    if ancestors.empty?
      resource.children.each do |child|
        li_options = { :id => child.id }
        li_options.merge!(:class => 'hasChildren') if child.has_children?
        result += content_tag :li, li_options do
          res = ""
          res += content_tag(:span, link_to(child.slug, child))
          res += content_tag(:ul, content_tag(:li, content_tag(:span, raw('&nbsp;'), :class => 'placeholder'))) if child.has_children?
          raw res
        end
      end
      return raw(result)
    end
    node = ancestors.shift
    node.siblings.each do |sibling|
      li_options = { :id => sibling.id }
      li_options.merge!(:class => 'hasChildren') if sibling.has_children?
      li_options[:class] += " open" if node == sibling && sibling.has_children?
      result += content_tag :li, li_options do
        res = ""
        res += content_tag(:span, link_to(sibling.slug, sibling))
        res += content_tag :ul do
          node == sibling ? expanded_ancestors(ancestors) : content_tag(:li, content_tag(:span, raw('&nbsp;'), :class => 'placeholder'))
        end if sibling.has_children?
        raw res
      end
    end
    raw(result)
  end


end
