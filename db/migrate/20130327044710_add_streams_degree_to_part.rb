class AddStreamsDegreeToPart < ActiveRecord::Migration
  def change
    add_column :parts, :streams_degree, :string
  end
end
