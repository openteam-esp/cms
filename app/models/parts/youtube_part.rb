class YoutubePart < Part
  belongs_to :item_page, :class_name => 'Node', :foreign_key => :youtube_item_page_id

  validates_presence_of :youtube_kind, :youtube_object_id

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
    def youtube_resource
      youtube_kind_playlist? ? Youtube::Playlist.new(object_attributes) : Youtube::User.new(object_attributes)
    end

    def object_attributes
      { :id => youtube_object_id, :item_page => item_page, :max_results => youtube_per_page }
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
