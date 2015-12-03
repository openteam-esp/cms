class NavigationPart < Part
  attr_accessible :navigation_end_level,
                  :navigation_from_id,
                  :navigation_group,
                  :grouping_items_attributes

  has_many :grouping_items
  accepts_nested_attributes_for :grouping_items, :allow_destroy => true

  belongs_to :from_node, :foreign_key => :navigation_from_id, :class_name => 'Node'

  validates_presence_of :from_node, :navigation_end_level

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  def part_title
    title
  end

  def content
    build_navigation_tree(from_node)
  end

  def response_status
    nil
  end

  private
    def selected_children(node)
      return node.children.where(:navigation_group => navigation_group).order('navigation_position') if navigation_group?

      node.children.order('navigation_position')
    end

    def node_hash(node)
      {
        'title' => node.navigation_title.blank? ? node.title : node.navigation_title,
        'alternative_title' => node.alternative_title,
        'path' => "#{node.route_without_site}",
        'external_link' => node.external_link.to_s,
        'lastmod' => node.updated_at,
        'navigation_group' => node.navigation_group,
        'selected' => current_node.path_ids.include?(node.id) # FIXME what is it? => && node != from_node
      }
    end

    def build_navigation_tree(node)
      hash = { node.slug => node_hash(node) }

      if node.depth - from_node.depth < navigation_end_level
        selected_children(node).navigable.each do |child|
          hash[node.slug]['children'] ||= {}
          hash[node.slug]['children'].merge!(build_navigation_tree(child))
        end
        grouped_children = grouping_children(grouping_items.order('position'), node)
        unless grouped_children.empty?
          hash[node.slug]['grouping_children'] ||= {}
          hash[node.slug]['grouping_children'].merge!(grouped_children)
        end
      end

      hash
    end

    def grouping_children(items, node)
      h = {}
      items.each do |item|
        children = node.descendants.navigable.where(:navigation_group => item.group, :page_for_redirect_id => nil).map{ |child| node_hash(child) }
        h[item.group] = { :title => item.title, :children => children } if children.any?
      end

      h
    end

    def urls_for_index
      []
    end
end

# == Schema Information
#
# Table name: parts
#
#  id                                     :integer          not null, primary key
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  region                                 :string(255)
#  type                                   :string(255)
#  node_id                                :integer
#  navigation_end_level                   :integer
#  navigation_from_id                     :integer
#  navigation_default_level               :integer
#  news_channel                           :string(255)
#  news_per_page                          :integer
#  news_paginated                         :boolean
#  news_item_page_id                      :integer
#  blue_pages_category_id                 :integer
#  appeal_section_slug                    :string(255)
#  navigation_group                       :string(255)
#  title                                  :text
#  html_info_path                         :text
#  blue_pages_item_page_id                :integer
#  documents_kind                         :string(255)
#  documents_item_page_id                 :integer
#  documents_paginated                    :boolean
#  documents_per_page                     :integer
#  news_height                            :integer
#  news_width                             :integer
#  news_mlt_count                         :integer
#  news_mlt_width                         :integer
#  news_mlt_height                        :integer
#  template                               :string(255)
#  text_info_path                         :text
#  news_event_entry                       :string(255)
#  blue_pages_expand                      :integer
#  documents_contexts                     :string(255)
#  search_per_page                        :integer
#  organization_list_category_id          :integer
#  organization_list_per_page             :integer
#  organization_list_item_page_id         :integer
#  directory_presentation_id              :integer
#  directory_presentation_item_page_id    :integer
#  directory_presentation_photo_width     :integer
#  directory_presentation_photo_height    :integer
#  directory_presentation_photo_crop_kind :string(255)
#  directory_post_photo_width             :integer
#  directory_post_photo_height            :integer
#  directory_post_photo_crop_kind         :string(255)
#  directory_post_post_id                 :integer
#  gpo_project_list_chair_id              :integer
#  streams_degree                         :string(255)
#  provided_disciplines_subdepartment     :string(255)
#  news_mlt_number_of_months              :integer          default(1)
#
