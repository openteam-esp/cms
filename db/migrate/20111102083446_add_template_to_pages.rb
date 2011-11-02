class AddTemplateToPages < ActiveRecord::Migration
  def change
    add_column :pages, :template_id, :integer
    add_index :pages, :template_id
  end
end
