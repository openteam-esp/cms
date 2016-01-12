require 'progress_bar'

task :import_faculties => :environment do
  structure = RestClient::Request.execute(
    :method => :get,
    :url => 'https://directory.tusur.ru/api/structure.json',
    :timeout => 600,
    headers: { :Accept => 'application/json', :timeout => 600  }) do |response, request, result, &block|
      JSON.parse(response.body)
    end

    pg = ProgressBar.new(structure.count)

    structure.each do |faculty|
      full_title = "#{faculty['title']} (#{faculty['abbr']})"
      title = faculty['title']
      page = Page.new(:title => title)
      page = Page.find(501).children.find_by_slug(page.send(:generate_slug)) || page
      page.parent = Page.find(501)
      page.template = 'faculty'
      page.navigation_group = 'faculties'
      page.title = full_title
      page.navigation_title = full_title

      page.save!

      if faculty['chairs'].any?
        faculty['chairs'].each do |chair|
          full_title = "#{chair['title']} (#{chair['abbr']})"
          title = chair['title']
          child = Page.new(:title => title)
          child = page.children.find_by_slug(child.send(:generate_slug)) || child
          child.parent = page
          child.template = 'chair'
          child.navigation_group = 'chairs'
          child.title = full_title
          child.navigation_title = full_title

          child.save!
        end
      end

      pg.increment!
    end
end
