class NewsCollectionItem < ActiveRecord::Base

  attr_accessible :count, :title, :node_id, :news_collection_part_id, :position

  belongs_to :node
  belongs_to :news_collection_part

  validates_presence_of :node_id, :count

  default_scope order(:position, :id)

  def to_json
    list_part = node.parts.where(:type => ['NewsListPart', 'YoutubeListPart']).first
    return {
      :title => title,
      :path => node.page_route,
      :error => 'На странице нет списка новостей'
    } if list_part.blank?
    list_part.params = {}
    list_part.news_per_page = count
    as_json(:only => [:title]).merge(
      :path => node.page_route,
      :type => list_part.type,
      :template => list_part.template,
      :items => list_part.content['items']
    )
  end
end

# == Schema Information
#
# Table name: news_collection_items
#
#  id                      :integer          not null, primary key
#  title                   :string(255)
#  node_id                 :integer
#  news_collection_part_id :integer
#  count                   :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  position                :integer
#
