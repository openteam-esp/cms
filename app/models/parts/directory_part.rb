class DirectoryPart < Part
  attr_accessor :directory_subdivision

  attr_accessible :directory_subdivision_id, :directory_depth, :directory_only_pps

  validates_presence_of :directory_subdivision_id, :directory_depth

  default_value_for :directory_depth, 1
  default_value_for :directory_only_pps, false

  after_initialize :check_subdivision_url, :unless => :new_record?

  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  def content
    response_hash['posts'].delete_if{ |post| post['pps'] == false } if directory_only_pps?

    response_hash
  end

  alias_attribute :part_title, :title

  def subdivisions
    @subdivisions ||= Requester.new("#{directory_url}", { headers: { Accept: 'application/json' } }).response_hash
  end

  def subdivision_name
    requester = Requester.new("#{directory_url}/#{directory_subdivision_id}", { headers: { Accept: 'application/json' } })
    @subdivision_name ||= requester.response_status == 200 ? requester.response_hash['title'] : "Подразделение не найдено в телефонном справочнике"
  end

  def check_subdivision_url
    subdivision = { :id => response_hash['id'], :url => response_hash['url'], :title => response_hash['title'] }

    if node.present? &&
       normalize_subdivision_title(node.title) == normalize_subdivision_title(subdivision[:title]) &&
       subdivision[:url] != node.url
      Requester.new("#{Settings['directory.url']}/api/set_subdivision_url", { payload: { id: subdivision[:id], url: node.url }, method: :put })
    end
  end

  def normalize_subdivision_title(title)
    title.split('(').first.squish.mb_chars.downcase.gsub(/[[:space:]]/, ' ') rescue ''
  end

  private

    def need_to_reindex?
      directory_subdivision_id_changed? || directory_depth_changed? || super
    end

    def directory_url
      "#{Settings['directory.url']}/api/subdivisions"
    end

    def depth_parameter
      directory_depth.to_i.zero? ? '' : "?depth=#{directory_depth}"
    end

    def url_for_request
      "#{directory_url}/#{directory_subdivision_id}#{depth_parameter}"
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
#  directory_subdivision_id               :integer
#  directory_depth                        :integer
#  priem_context_id                       :integer
#  priem_context_kind                     :string(255)
#  priem_kinds                            :string(255)
#  priem_forms                            :string(255)
#  storage_directory_id                   :integer
#  storage_directory_name                 :string(255)
#  storage_directory_depth                :integer
#  directory_only_pps                     :boolean
#
