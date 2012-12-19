class AddWidthAndHeightAndCropKindToDirectoryPresentationPart < ActiveRecord::Migration
  def change
    add_column :parts, :directory_presentation_photo_width, :integer
    add_column :parts, :directory_presentation_photo_height, :integer
    add_column :parts, :directory_presentation_photo_crop_kind, :string
  end
end
