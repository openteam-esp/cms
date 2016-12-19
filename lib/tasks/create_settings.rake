namespace :settings do
  desc 'Создать связку с настройками для каждого сайта'
  task create: :environment do
    sites_yaml = YAML.load_file('config/sites.yml')['sites']

    pb = ProgressBar.new Site.count

    Site.find_each do |site|
      setup = site.build_setup

      site_yaml = sites_yaml.select { |s| s == site.slug }[site.slug]
      templates = site_yaml['templates']
      part_templates = site_yaml['part_templates']

      templates.each do |template|
        template_title, regions = template
        temp = setup.templates.build title: template_title

        regions.each do |region|
          reg_title, settings = region

          temp.regions.build title: reg_title,
                             required: settings['required'].presence || false,
                             configurable: settings['configurable'].presence || false,
                             indexable: settings['indexable'].presence || false
        end
      end

      # завернуто, ибо может не быть part_template в sites.yml
      begin
        part_templates.each do |template|
          part_template_title, values = template
          setup.part_templates.build title: part_template_title, values: values
        end
      rescue
        puts "Не нашел part_templates в sites.yml для сайта #{site.title}"
      end

      setup.save!

      pb.increment!
    end
  end
end
