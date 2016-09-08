class PriemPart < Part
  attr_accessor :priem_context

  attr_accessible :priem_context_id, :priem_context_kind, :priem_kinds, :priem_forms

  validates_presence_of :priem_kinds, :priem_forms

  extend Enumerize

  serialize :priem_kinds, Array
  enumerize :priem_kinds, in: [
    'bachelor', 'specialist', 'magister'
  ], multiple: true

  default_value_for :priem_kinds, ['bachelor', 'specialist', 'magister']

  serialize :priem_forms, Array
  enumerize :priem_forms, in: [
    'fulltime', 'correspondence'
  ], multiple: true

  default_value_for :priem_forms, ['fulltime']
  def to_json
    super.merge!(as_json(:only => :type, :methods => ['part_title', 'content']))
  end

  def content
    response_hash
  end

  alias_attribute :part_title, :title

  def contexts
    @contexts ||= Requester.new("#{priem_context_url}", { headers: { Accept: 'application/json' } }).response_hash
  end

  def context_title
    return unless priem_context_id.present?

    requester = Requester.new("#{priem_context_url}/#{priem_context_id}?context_kind=#{priem_context_kind}", { headers: { Accept: 'application/json' } })
    @context_title ||= requester.response_status == 200 ? requester.response_hash['title'] : "Подразделение не найдено в личном кабинете абитуриента"
  end

  private

    def need_to_reindex?
      priem_context_id_changed? || priem_kinds_changed? || priem_forms_changed? || super
    end

    def priem_context_url
      "#{Settings['priem.url']}/api/subdivisions"
    end

    def priem_programs_url
      "#{Settings['priem.url']}/api/programs"
    end

    def priem_kinds_param
      kinds = priem_kinds.values.map{ |k| "kinds[]=#{k}" }.join('&')

      "&#{kinds}"
    end

    def priem_forms_param
      training_forms = priem_forms.values.map{ |tf| "training_forms[]=#{tf}" }.join('&')

      "&#{training_forms}"
    end

    def url_for_request
      "#{priem_programs_url}?context_id=#{priem_context_id}&context_kind=#{priem_context_kind}#{priem_kinds_param}#{priem_forms_param}"
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
