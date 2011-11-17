require 'spec_helper'

describe HtmlPart do
  it { should belong_to :content }

  describe "should update content body" do
    let (:part) { Fabricate(:html_part, :body => "text") }

    it "on create" do
      part.content.body.should == "text"
      part.body.should == "text"
    end
    it "on update" do
      part.update_attributes(:body => "othertext")
      part.content.body.should == "othertext"
      part.body.should == "othertext"
    end
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
#  news_paginated           :boolean
#  news_item_page_id        :integer
#

