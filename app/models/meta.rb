class Meta < ActiveRecord::Base
  attr_accessible :description, :keywords, :url, :image, :delete_image
  attr_accessible :og_type, :og_site_name, :og_title, :og_description, :og_locale, :og_locale_alternate
  attr_accessible :twitter_card, :twitter_domain, :twitter_site, :twitter_creator, :twitter_title, :twitter_description

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']
  validates_attachment :image, :content_type => {
    :content_type => ['image/jpeg', 'image/jpg', 'image/png'],
    :message => 'Изображение должно быть в формате jpeg, jpg или png' }

  attr_accessor :delete_image
  before_validation { image.clear if delete_image == '1' }

  alias_attribute :file_url, :image_url

  belongs_to :metable, :polymorphic => true

  default_value_for :og_type, :website

  default_value_for :og_site_name do |obj|
    obj.metable.site
  end

  default_value_for :og_locale, 'ru_RU'

  default_value_for :twitter_domain do |obj|
    obj.metable.site.client_url
  end

  default_value_for :twitter_site do |obj|
    "@#{obj.metable.site.slug}"
  end

  default_value_for :twitter_creator do |obj|
    "@#{obj.metable.site.slug}"
  end
end

# == Schema Information
#
# Table name: metas
#
#  id                  :integer          not null, primary key
#  description         :text
#  keywords            :text
#  url                 :string(255)
#  og_title            :text
#  og_description      :text
#  og_type             :string(255)
#  og_locale           :string(255)
#  og_locale_alternate :string(255)
#  og_site_name        :string(255)
#  twitter_card        :string(255)
#  twitter_site        :string(255)
#  twitter_creator     :string(255)
#  twitter_title       :string(255)
#  twitter_description :text
#  twitter_domain      :string(255)
#  metable_id          :integer
#  metable_type        :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  image_file_name     :string(255)
#  image_content_type  :string(255)
#  image_file_size     :integer
#  image_updated_at    :datetime
#  image_url           :text
#
