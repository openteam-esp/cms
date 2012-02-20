class AddFieldsToYoutubeVideoPart < ActiveRecord::Migration
  def change
    add_column :parts, :youtube_video_related_count, :integer
    add_column :parts, :youtube_video_width, :integer
    add_column :parts, :youtube_video_height, :integer
  end
end
