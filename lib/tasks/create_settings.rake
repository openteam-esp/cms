namespace :settings do
  desc 'Создать связку с настройками для каждого сайта'
  task create: :environment do
    sites_yaml = YAML.load_file('config/sites.yml')['sites']

    pb = ProgressBar.new Site.count

    Site.find_each do |site|
      setup = site.build_setup

      site_yaml = sites_yaml.select { |s| s == site.slug }[site.slug]
      templates = site_yaml['templates']

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

      setup.save!

      pb.increment!
    end
  end
end
