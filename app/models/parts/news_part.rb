# encoding: utf-8

class NewsPart < Part
  validates_presence_of :news_order_by

  has_enums

  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    hash = request_body

    hash.merge!(pagination)
  end

  def request
    @request ||= Restfulie.at("#{news_url}/public/entries?#{search_path}").accepts("application/json").get
  end

  def request_body
    ActiveSupport::JSON.decode request.body
  end

  def pagination
    hash = { 'pagination' => [] }

    (1..request.headers['x-total-pages'].to_i).each do |page|
      hash['pagination'] << { 'link' => "page#{page}", 'current' => request.headers['x-current-page'].to_i == page ? 'true' : 'false' }
    end

    hash
  end

  private
    def news_url
      "#{Settings['news.protocol']}://#{Settings['news.host']}:#{Settings['news.port']}"
    end

    def search_path
      news_until = ::I18n.l(news_until) if news_until
      URI.escape "utf8=✓&entry_search[channel_slugs][]=#{news_channel}&entry_search[order_by]=#{news_order_by.gsub(/_/,'+')}&entry_search[until_lt]=#{news_until}&per_page=#{news_per_page}&page=#{node.parts_params[:news][:page]}"
    end
end


# == Schema Information
#
# Table name: parts
#
#  id                       :integer         not null, primary key
#  html_content_id          :integer
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
#

