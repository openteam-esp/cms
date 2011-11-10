# encoding: utf-8

require 'spec_helper'

describe Node do
  it { should validate_presence_of :slug }
  it { should allow_value('test_node123').for(:slug) }
  it { should allow_value('русские-буковки').for(:slug) }
  it { should_not allow_value('test/').for(:slug) }
  it { should normalize_attribute(:title).from('"English" "Русский"').to('“English” «Русский»') }

  describe 'сохранение path' do
    let(:root) { Fabricate(:node, :parent => nil, :slug => 'site') }
    let(:ru) { Fabricate(:node, :parent => root, :slug => 'ru') }
    let(:about) { Fabricate(:node, :parent => ru, :slug => 'about') }

    it { root.route.should == 'site' }
    it { ru.route.should == 'site/ru' }
    it { about.route.should == 'site/ru/about' }
  end
end

# == Schema Information
#
# Table name: nodes
#
#  id         :integer         not null, primary key
#  slug       :string(255)
#  title      :string(255)
#  ancestry   :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  route      :text
#  template   :string(255)
#  client_url :string(255)
#

