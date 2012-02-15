class YoutubePart < Part
  belongs_to :item_page, :class_name => 'Node', :foreign_key => :youtube_item_page_id

  validates_presence_of :youtube_resource_id, :youtube_resource_kind

  default_value_for :youtube_per_page, 10

  has_enums

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  delegate :entries,                              :to => :youtube_resource, :prefix => true
  delegate :video_id, :video_title, :video_thumb, :to => :youtube_resource

  def content
    entries
  end

  private
    def resource_attributes
      { :id => youtube_resource_id, :item_page => item_page, :max_results => youtube_per_page }
    end

    def youtube_resource
      youtube_resource_kind_playlist? ? Youtube::Playlist.new(resource_attributes) : Youtube::User.new(resource_attributes)
    end

    def entries
      youtube_resource_entries.map do |e|
        video_id = video_id(e)

        {
          'link' => "#{item_page.route_without_site}?parts_params[youtube_video][id]=#{video_id}",

          'video' => {
            'title'  => video_title(e),
            'thumb'  => video_thumb(video_id)
          },
        }
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
#

