require 'progress_bar'

def index(parts)
  urls = parts.flat_map{|p| p.send(:urls_for_index) if p.indexable?}.compact.uniq
  bar = ProgressBar.new(urls.count)
  urls.each do |url|
    begin
      MessageMaker.make_message('esp.cms.searcher', 'add', url)
    rescue => e
      logger.fatal "Error make message with: #{e.inspect}"
    end
    bar.increment!
  end
end

desc "Reindex site"
task :reindex_site, [:slug] => :environment do |t, args|
  site = Site.find_by_slug! args.slug
  begin
    MessageMaker.make_message('esp.cms.searcher', 'remove', site.client_url)
  rescue => e
    logger.fatal "Error make message with: #{e.inspect}"
  end
  index Part.includes(:node).where(site.descendant_conditions)
end

desc "Reindex parts"
task :reindex_parts, [:type] => :environment do |t, args|
  index Part.where(:type => args.type.to_s)
end

