class AddPaginatedToNewsListPart < ActiveRecord::Migration
  def change
    add_column :parts, :news_paginated, :boolean
  end
end
