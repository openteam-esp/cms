class AddAppealSectionSlugToPart < ActiveRecord::Migration
  def change
    add_column :parts, :appeal_section_slug, :string
  end
end
