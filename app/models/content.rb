class Content < ActiveRecord::Base

  normalize_attribute :body, :with => [:sanitize, :gilensize_as_html, :strip, :blank]

  def to_s
    title
  end
end

# == Schema Information
#
# Table name: contents
#
#  id         :integer         primary key
#  title      :string(255)
#  body       :text
#  created_at :timestamp
#  updated_at :timestamp
#

