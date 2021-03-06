require 'spec_helper'

describe Site do
  it { should validate_presence_of :slug }
end

# == Schema Information
#
# Table name: nodes
#
#  id                    :integer          not null, primary key
#  slug                  :string(255)
#  title                 :text
#  ancestry              :string(255)
#  type                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  route                 :text
#  template              :string(255)
#  client_url            :string(255)
#  in_navigation         :boolean
#  navigation_group      :string(255)
#  navigation_position   :integer
#  navigation_title      :text
#  ancestry_depth        :integer          default(0)
#  page_for_redirect_id  :integer
#  weight                :string(255)
#  external_link         :text
#  alternative_title     :text
#  locale_association_id :integer
#
