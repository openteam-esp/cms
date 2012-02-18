class AddYoutubeVideoPartWithRelatedToPart < ActiveRecord::Migration
  def change
    add_column :parts, :youtube_video_with_related, :boolean

  end
end
