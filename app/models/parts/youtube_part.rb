class YoutubePart < Part
  belongs_to :item_page, :class_name => 'Node', :foreign_key => :youtube_item_page_id

  validates_presence_of :youtube_resource_id, :youtube_resource_kind

  default_value_for :youtube_per_page, 10

  has_enums

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  delegate :entries,
           :total_count,
           :to => :youtube_resource, :prefix => true

  delegate :video_id,
           :video_title,
           :video_description,
           :video_uploaded,
           :video_thumb_small,
           :video_thumb_normal,
           :response_status, :to => :youtube_resource

  def part_title
    title
  end

  def content
    { 'items' => entries }.tap do |hash|
      hash.merge!(pagination) if youtube_paginated?
    end
  end

  private
    def resource_attributes
      { :id => youtube_resource_id, :item_page => item_page, :max_results => max_results, :start_index => start_index }
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
            'title' => video_title(e),
            'description' => video_description(e),
            'date' => video_uploaded(e),
            'thumb_small'  => video_thumb_small(video_id),
            'thumb_normal'  => video_thumb_normal(video_id)
          },
        }
      end
    end

    def total_count
      youtube_resource_total_count
    end

    def current_page
      (params['page'] || 1).to_i
    end

    def max_results
      youtube_per_page.to_i
    end

    def start_index
      (current_page - 1) * max_results + 1
    end

    def pagination
      {
        'pagination' => {
          'total_count' => total_count,
          'current_page' => current_page,
          'per_page' => youtube_per_page,
          'param_name' => 'parts_params[youtube][page]'
        }
      }
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
#  template                    :string(255)
#  youtube_video_with_related  :boolean
#  youtube_video_related_count :integer
#  youtube_video_width         :integer
#  youtube_video_height        :integer
#

