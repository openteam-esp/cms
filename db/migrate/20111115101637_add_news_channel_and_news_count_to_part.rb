class AddNewsChannelAndNewsCountToPart < ActiveRecord::Migration
  def change
    add_column :parts, :news_channel, :string
    add_column :parts, :news_count, :integer
  end
end
