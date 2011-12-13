# encoding: utf-8

class BluePagesPart < Part
  validates_presence_of :blue_pages_category_id

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    ActiveSupport::JSON.decode request.body
  end

  def request
    @request ||= Restfulie.at("#{blue_pages_url}/#{blue_pages_category_id}#{expand_parameter}").accepts("application/json").get
  end

  def expand_parameter
    '?expand=true' if blue_pages_expand
  end

  def categories
    @categories ||= Restfulie.at(blue_pages_url).accepts("application/json").get
  end

  def category_name
    @name ||= ActiveSupport::JSON.decode(Restfulie.at("#{blue_pages_url}/#{blue_pages_category_id}").accepts("application/json").get.body)['title']
  end

  def categories_options_for_select
    options_for_select = {}
    ActiveSupport::JSON.decode(categories.body)['categories'].each do |e|
      options_for_select[e['title']] = e['id']
    end

    options_for_select
  end

  private
    def blue_pages_url
      "#{Settings['blue_pages.protocol']}://#{Settings['blue_pages.host']}:#{Settings['blue_pages.port']}/categories"
    end
end

# == Schema Information
#
# Table name: parts
#
#  id                       :integer         not null, primary key
#  created_at               :datetime
#  updated_at               :datetime
#  region                   :string(255)
#  type                     :string(255)
#  node_id                  :integer
#  navigation_end_level     :integer
#  navigation_from_id       :integer
#  navigation_default_level :integer
#  news_channel             :string(255)
#  news_order_by            :string(255)
#  news_until               :date
#  news_per_page            :integer
#  news_paginated           :boolean
#  news_item_page_id        :integer
#  blue_pages_category_id   :integer
#  appeal_section_slug      :string(255)
#  blue_pages_expand        :boolean
#  navigation_group         :string(255)
#  title                    :string(255)
#  html_info_path           :string(255)
#

