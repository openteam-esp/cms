def index(parts)
  parts.flat_map{|p| p.send(:urls_for_index) if p.indexable?}.compact.uniq.each do |url|
    MessageMaker.make_message('esp.cms.searcher', 'add', url)
  end
end

desc "Reindex site"
task :reindex_site, [:slug] => :environment do |t, args|
  site = Site.find_by_slug! args.slug
  MessageMaker.make_message('esp.cms.searcher', 'remove', site.client_url)
  index Part.includes(:node).where(site.descendant_conditions)
end

desc "Reindex parts"
task :reindex_parts, [:type] => :environment do |t, args|
  raise "cann't detect part type '#{args.type}'" unless Part.descendants.map(&:to_s).include?(type = args.type.to_s.classify)
  index Part.where(:type => type)
end

