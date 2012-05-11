# encoding: utf-8

class BluePagesPart < Part
  belongs_to :item_page, :class_name => 'Node', :foreign_key => :blue_pages_item_page_id

  validates_presence_of :blue_pages_category_id, :blue_pages_expand

  default_value_for :blue_pages_expand, 0

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  def content
    set_subdivision_paths
    update_item_links
  end

  alias_attribute :part_title, :title

  def categories
    @categories ||= Requester.new("#{blue_pages_url}", 'application/json').response_hash['categories'].map { |c| [c['title'], c['id']] }
  end

  def category_name
    @category_name ||= Requester.new("#{blue_pages_url}/#{blue_pages_category_id}", 'application/json').response_hash['title']
  end

  #
  # title гиленсезируется, поэтому ищется так
  #
  def find_page_by_title(title)
    # NOTE: Page.all офигенно фиговая практика
    # TODO: искать ч/з Sunspot или сохранять дублированное поле без гиленсизации
    Page.all.detect { |node| node.title.gsub(/[[:space:]]/, ' ') == title }
  end

  def administration_page
    find_page_by_title('Администрация Томской области')
  end

  private
    def blue_pages_url
      "#{Settings['blue-pages.url']}/categories"
    end

    def expand_parameter
      blue_pages_expand.to_i.zero? ? '' : "?expand=#{blue_pages_expand}"
    end

    def url_for_request
      "#{blue_pages_url}/#{blue_pages_category_id}#{expand_parameter}"
    end

    #
    # example: /categories/94/items/246.json -> /ru/item/-/categories/94/items/246.json
    #
    def update_item_links(subdivisions = response_hash)
      subdivisions['items'].each { |item|
        item['link'] = "#{item_page.route_without_site}/-#{item['link']}" if item['link']
      } if subdivisions['items']

      subdivisions['categories'].each { |subdivision| update_item_links(subdivision) } if subdivisions['categories']
      subdivisions['subdivisions'].each { |subdivision| update_item_links(subdivision) } if subdivisions['subdivisions']

      subdivisions
    end

    def set_subdivision_paths
      if administration_page
        response_hash['subdivisions'].each do |subdivision|
          if node = find_page_by_title(subdivision['title'])
            subdivision['path'] = node.route_without_site
          end
        end if response_hash['subdivisions'].try(:any?)
      end
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

