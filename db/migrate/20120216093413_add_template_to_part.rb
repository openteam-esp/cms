class AddTemplateToPart < ActiveRecord::Migration
  def up
    add_column :parts, :template, :string

    Part.all.each do |part|
      part.update_attribute(:template, part.type.underscore)
    end
  end

  def down
    remove_column :parts, :template
  end
end
