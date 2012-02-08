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
