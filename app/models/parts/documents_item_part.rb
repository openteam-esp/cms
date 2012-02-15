class DocumentsItemPart < Part
  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    request_body.tap do |paper|
      paper['asserted_projects']  = change_ids_to_links(paper['asserted_projects'])
      paper['canceled_documents'] = change_ids_to_links(paper['canceled_documents'])
      paper['changed_documents']  = change_ids_to_links(paper['changed_documents'])
    end
  end

  def page_title
    content['title']
  end

  private
    def documents_url
      "#{Settings['documents.url']}"
    end

    def request
      @request ||= Curl::Easy.http_get("#{documents_url}/papers/#{paper_id}.json").body_str
    end

    def request_body
      ActiveSupport::JSON.decode(request).tap { |hash| hash.delete('id') }
    end

    def paper_id
      params.try(:[], 'id')
    end

    def change_ids_to_links(papers)
      if papers
        papers.map { |p| p.merge!('link' => "#{node.route_without_site}?parts_params[documents_item][id]=#{p['id']}") }
        papers.each { |p| p.delete('id') }
      else
        []
      end
    end
end
# == Schema Information
#
# Table name: parts
#
#  id                          :integer         not null, primary key
#  created_at                  :datetime
#  updated_at                  :datetime
#  region                      :string(255)
#  type                        :string(255)
#  node_id                     :integer
#  navigation_end_level        :integer
#  navigation_from_id          :integer
#  navigation_default_level    :integer
#  news_channel                :string(255)
#  news_order_by               :string(255)
#  news_until                  :date
#  news_per_page               :integer
#  news_paginated              :boolean
#  news_item_page_id           :integer
#  blue_pages_category_id      :integer
#  appeal_section_slug         :string(255)
#  blue_pages_expand           :boolean
#  navigation_group            :string(255)
#  title                       :string(255)
#  html_info_path              :string(255)
#  blue_pages_item_page_id     :integer
#  documents_kind              :string(255)
#  documents_item_page_id      :integer
#  documents_paginated         :boolean
#  documents_per_page          :integer
#  documents_context_id        :integer
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
#

