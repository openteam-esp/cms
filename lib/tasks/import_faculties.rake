require 'progress_bar'

desc 'import faculties and subfaculties'
task import_faculties: :environment do
  structure = RestClient::Request.execute(
    method: :get,
    url: "#{Settings['directory.url']}/api/structure.json",
    timeout: 600,
    headers: { Accept: 'application/json', timeout: 600 }
  ) do |response, _request, _result|
    JSON.parse(response.body)
  end

  pg = ProgressBar.new(structure.count)

  structure.each do |faculty|
    full_title = faculty['abbr'].present? ? "#{faculty['title']} (#{faculty['abbr']})" : (faculty['title']).to_s
    title = faculty['title']
    page = Page.new(title: title)
    page = Page.find(501).children.find_by_slug(page.send(:generate_slug)) || page
    page.parent = Page.find(501)
    page.template = 'faculty'
    page.navigation_group = 'faculties'
    page.title = full_title
    page.navigation_title = full_title

    page.save!
    parts = page.parts.where(region: 'content', type: 'DirectoryPart', template: 'directory_part', directory_subdivision_id: faculty['id'].to_i)
    parts.first.destroy if parts.any?

    DirectoryPart.create! region: 'content', template: 'directory_part', directory_subdivision_id: faculty['id'].to_i, directory_depth: 1, node: page

    if faculty['chairs'].any?
      faculty['chairs'].each do |chair|
        full_title = chair['abbr'].present? ? "#{chair['title']} (#{chair['abbr']})" : (chair['title']).to_s
        title = chair['title']
        child = Page.new(title: title)
        child = page.children.find_by_slug(child.send(:generate_slug)) || child
        child.parent = page
        child.template = 'chair'
        child.navigation_group = 'chairs'
        child.title = full_title
        child.navigation_title = full_title

        child.save!

        parts = child.parts.where(region: 'content', type: 'DirectoryPart', template: 'directory_part', directory_subdivision_id: chair['id'].to_i)
        parts.first.destroy if parts.any?
        DirectoryPart.create! region: 'content', template: 'directory_part', directory_subdivision_id: chair['id'].to_i, directory_depth: 1, node: child
      end
    end

    pg.increment!
  end
end
