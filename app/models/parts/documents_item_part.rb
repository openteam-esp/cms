class DocumentsItemPart < Part
  def to_json
    super.merge!(as_json(:only => :type, :methods => ['content', 'part_title']))
  end

  def content
    response_hash.delete('id')

    response_hash.tap do |paper|
      paper['asserted_projects']  = change_ids_to_links(paper['asserted_projects'])
      paper['canceled_documents'] = change_ids_to_links(paper['canceled_documents'])
      paper['changed_documents']  = change_ids_to_links(paper['changed_documents'])
    end
  end

  def part_title
    content['title']
  end

  alias :page_title :part_title

  private
    def documents_url
      "#{Settings['documents.url']}"
    end

    alias :paper_id :resource_id

    def url_for_request
      "#{documents_url}/papers/#{paper_id}"
    end

    def change_ids_to_links(papers)
      return [] unless papers

      papers.map { |p| p.merge!('link' => "#{node.route_without_site}/-/#{p['id']}") }
      papers.each { |p| p.delete('id') }
    end

    def urls_for_index
      []
    end
end

# == Schema Information
#
# Table name: parts
#
#  id                          :integer         not null, primary key
#  created_at                  :datetime        not null
#  updated_at                  :datetime        not null
#  region                      :string(255)
#  type                        :string(255)
#  node_id                     :integer
#  navigation_end_level        :integer
#  navigation_from_id          :integer
#  navigation_default_level    :integer
#  news_channel                :string(255)
#  news_until                  :date
#  news_per_page               :integer
#  news_paginated              :boolean
#  news_item_page_id           :integer
#  blue_pages_category_id      :integer
#  appeal_section_slug         :string(255)
#  navigation_group            :string(255)
#  title                       :string(255)
#  html_info_path              :string(255)
#  blue_pages_item_page_id     :integer
#  documents_kind              :string(255)
#  documents_item_page_id      :integer
#  documents_paginated         :boolean
#  documents_per_page          :integer
#  youtube_resource_id         :string(255)
#  youtube_item_page_id        :integer
#  youtube_video_resource_id   :string(255)
#  youtube_resource_kind       :string(255)
#  youtube_per_page            :integer
#  youtube_paginated           :boolean
#  youtube_video_resource_kind :string(255)
#  news_height                 :integer
#  news_width                  :integer
#  news_mlt_count              :integer
#  news_mlt_width              :integer
#  news_mlt_height             :integer
#  template                    :string(255)
#  youtube_video_with_related  :boolean
#  youtube_video_related_count :integer
#  youtube_video_width         :integer
#  youtube_video_height        :integer
#  text_info_path              :string(255)
#  news_event_entry            :string(255)
#  blue_pages_expand           :integer
#  documents_contexts          :string(255)
#  search_per_page             :integer
#

