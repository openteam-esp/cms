class NewsCollectionItem < ActiveRecord::Base
  belongs_to :node
  belongs_to :news_collection_part
  attr_accessible :count, :title, :node_id, :news_collection_part_id
  validates_presence_of :title, :node_id, :count
end
