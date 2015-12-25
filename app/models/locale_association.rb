class LocaleAssociation < ActiveRecord::Base
  attr_accessor :page_ids
  attr_accessible :page_ids

  belongs_to :site

  has_many :pages

  accepts_nested_attributes_for :pages

  before_validation :normalize_page_ids
  after_save :associate_pages

  validate :validate_page_ids


  def title
    pages.pluck(:title).join("/")
  end

  private

  def associate_pages
    page_ids.each do |id|
      page = Page.find(id)
      page.locale_association = self
      page.save
    end
  end

  def normalize_page_ids
    page_ids.delete_if(&:blank?)
  end

  def validate_page_ids
    errors[:page_ids] = "Все поля обязательны для заполнения" if page_ids.empty?
  end
end
