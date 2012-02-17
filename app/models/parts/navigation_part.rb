class NavigationPart < Part
  belongs_to :from_node, :foreign_key => :navigation_from_id, :class_name => 'Node'

  validates_presence_of :from_node, :navigation_end_level

  def to_json
    super.merge!(as_json(:only => :type, :methods => 'content'))
  end

  def content
    build_navigation_tree(from_node)
  end

  def response_status
    200
  end

  private
    def selected_children(node)
      return node.children.where(:navigation_group => navigation_group).order('navigation_position') if navigation_group
      node.children.order('navigation_position')
    end

    def build_navigation_tree(node)
      hash = { node.slug => { 'title' => node.navigation_title.blank? ? node.title : node.navigation_title, 'path' => "#{node.route_without_site}/" } }

      hash[node.slug].merge!('selected' => true) if current_node.path_ids.include?(node.id) && node != from_node

      selected_children(node).navigable.each do |child|
        hash[node.slug]['children'] ||= {}
        hash[node.slug]['children'].merge!(build_navigation_tree(child))
      end if node.depth - from_node.depth < navigation_default_level || (node.depth - from_node.depth < navigation_end_level && current_node.path_ids.include?(node.id))

      hash
    end
end

# == Schema Information
#
# Table name: parts
#
#  id                          :integer         not null, primary key
#  created_at                  :datetime
#  updated_at                  :datetime
#  region                      :string(255)
#  type                        :string(255)
#  node_id                     :integer
#  navigation_end_level        :integer
#  navigation_from_id          :integer
#  navigation_default_level    :integer
#  news_channel                :string(255)
#  news_order_by               :string(255)
#  news_until                  :date
#  news_per_page               :integer
#  news_paginated              :boolean
#  news_item_page_id           :integer
#  blue_pages_category_id      :integer
#  appeal_section_slug         :string(255)
#  blue_pages_expand           :boolean
#  navigation_group            :string(255)
#  title                       :string(255)
#  html_info_path              :string(255)
#  blue_pages_item_page_id     :integer
#  documents_kind              :string(255)
#  documents_item_page_id      :integer
#  documents_paginated         :boolean
#  documents_per_page          :integer
#  documents_context_id        :integer
#  youtube_resource_id         :string(255)
#  youtube_item_page_id        :integer
#  youtube_video_resource_id   :string(255)
#  youtube_resource_kind       :string(255)
#  youtube_per_page            :integer
#  youtube_paginated           :boolean
#  youtube_video_resource_kind :string(255)
#  news_height                 :integer
#  news_width                  :integer
#  news_mlt_count              :integer
#  news_mlt_width              :integer
#  news_mlt_height             :integer
#

