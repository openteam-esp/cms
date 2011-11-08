# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.id_generator = Proc.new { |key| "toolbar_#{key}" }

  navigation.active_leaf_class = 'leaf'

  navigation.items do |primary|
    primary.item :sites, I18n.t('toolbar.sites'), sites_path,
      :highlights_on => /^\/$|^\/sites|\/templates|\/pages/
    primary.item :contents, I18n.t('toolbar.contents'), contents_path,
      :highlights_on => /^\/contents/
    primary.item :contents, I18n.t('toolbar.uploads'), uploads_path,
      :highlights_on => /^\/uploads/

    primary.dom_id = 'toolbar'
  end

end
