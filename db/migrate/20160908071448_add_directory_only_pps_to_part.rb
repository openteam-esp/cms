class AddDirectoryOnlyPpsToPart < ActiveRecord::Migration
  def up
    add_column :parts, :directory_only_pps, :boolean
    DirectoryPart.find_each { |part| part.update_attribute :directory_only_pps, false }
  end

  def down
    remove_column :parts, :directory_only_pps
  end
end
