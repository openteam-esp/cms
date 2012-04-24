module EspCmsHelper
  def stub_sites_yml_for_all_nodes
    Node.any_instance.stub(:site_settings).and_return(sites_settings['sites']['www.tgr.ru'])
    Site.any_instance.stub(:site_settings).and_return(sites_settings['sites']['www.tgr.ru'])
    Locale.any_instance.stub(:site_settings).and_return(sites_settings['sites']['www.tgr.ru'])
    Page.any_instance.stub(:site_settings).and_return(sites_settings['sites']['www.tgr.ru'])
  end

  def sites_settings
    @site_settings ||= YAML.load_file(Rails.root.join 'spec/fixtures/sites.yml')
  end
end
