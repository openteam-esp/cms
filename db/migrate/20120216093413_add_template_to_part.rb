class AddTemplateToPart < ActiveRecord::Migration
  def change
    add_column :parts, :template, :string

  end
end
