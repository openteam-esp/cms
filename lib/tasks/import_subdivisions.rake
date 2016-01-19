require 'progress_bar'

desc 'import subdivisions'
task :import_subdivisions => :environment do
  structure = RestClient::Request.execute(
    :method => :get,
    :url => "#{Settings['directory.url']}/api/subdivisions/317?depth=2",
    :timeout => 600,
    headers: { :Accept => 'application/json', :timeout => 600  }) do |response, request, result, &block|
      JSON.parse(response.body)
    end

    pb = ProgressBar.new(structure.count)
    recursive_page_creation(Page.find(500), structure, pb)
end



private

def recursive_page_creation(parent_page, subdivision, pb, depth=0)
  subdivision['children'].each do |child|
    title = child['title']
    page = Page.new(:title => title)
    page = parent_page.children.find_by_slug(page.send(:generate_slug)) || page
    page.parent = parent_page
    page.template = 'subdivision'
    page.navigation_group = 'subdivision'
    page.title = title
    page.navigation_title = title

    page.save!

    parts = page.parts.where(:region => 'directory_part', :type => 'DirectoryPart', :template => 'directory_part', :directory_subdivision_id => child['id'].to_i)
    parts.first.destroy if parts.any?
    DirectoryPart.create! :region => 'directory_part', :template => 'directory_part', :directory_subdivision_id => child['id'].to_i, :directory_depth => 1, :node => page

    pb.increment! if depth == 0
    recursive_page_creation(page, child, pb, depth + 1) if child["children"].present?
  end
end
