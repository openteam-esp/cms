# encoding: utf-8

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

  def blue_page_response_hash
    {
      'title' => 'Губернатор',
      'address' => '634050, Томская область, г. Томск, пл. Ленина, 6',
      'phones' => 'Тел.: (3822) 510-813, (3822) 510-505',
      'items' => [
        {
          'person' => 'Кресс Виктор Мельхиорович',
          'title' => 'Губернатор',
          'address' => '',
          'link' => '/categories/3/items/1',
          'phones' => 'Тел.: (3822) 510-813, (3822) 510-505'
        }
      ],

      'subdivisions' => [
        {
          'title' => 'Заместитель губернатора Томской области по особо важным проектам',
          'address' => '634050, Томская область, г. Томск, пл. Ленина, 6',
          'phones' => 'Тел.: (3822) 511-142',
          'items' => [
            {
              'person' => 'Точилин Сергей Борисович',
              'title' => 'Заместитель губернатора Томской области по особо важным проектам',
              'address' => '',
              'link' => '/categories/15/items/14',
              'phones' => 'Тел.: (3822) 511-142'
            }
          ]
        },

        { 'title' => 'Департамент по культуре' }
      ]
    }
  end

  def stub_blue_page_response
    BluePagesPart.any_instance.stub(:response_hash).and_return(blue_page_response_hash)
    BluePagesPart.any_instance.stub(:respense_status).and_return(200)
  end
end
