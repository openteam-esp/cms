require 'spec_helper'

describe NavigationPart do
  it { should belong_to :from_node }
  it { should validate_presence_of :from_node }
  it { should validate_presence_of :navigation_level }
  it { should validate_presence_of :navigation_selected_level }

  describe 'json' do
    let(:site) { Fabricate(:site, :slug => 'site', :title => 'site') }
      let(:locale) { Fabricate(:locale, :parent => site, :slug => 'ru', :title => 'ru') }
        let(:section1) { Fabricate(:page, :parent => locale, :slug => 'section1', :title => 'section1') }
          let(:subsection11) { Fabricate(:page, :parent => section1, :slug => 'subsection11', :title => 'subsection11') }
            let(:page111) { Fabricate(:page, :parent => subsection11, :slug => 'page111', :title => 'page111') }
            let(:page112) { Fabricate(:page, :parent => subsection11, :slug => 'page112', :title => 'page112') }
          let(:page11) { Fabricate(:page, :parent => section1, :slug => 'page11', :title => 'page11') }
        let(:section2) { Fabricate(:page, :parent => locale, :slug => 'section2', :title => 'section2') }
        let(:section3) { Fabricate(:page, :parent => locale, :slug => 'section3', :title => 'section3') }
          let(:subsection31) { Fabricate(:page, :parent => section3, :slug => 'subsection31', :title => 'subsection31') }
            let(:page311) { Fabricate(:page, :parent => subsection31, :slug => 'page311', :title => 'page311') }
          let(:subsection32) { Fabricate(:page, :parent => section3, :slug => 'subsection32', :title => 'subsection32') }
            let(:page321) { Fabricate(:page, :parent => subsection32, :slug => 'page321', :title => 'page321') }
          let(:subsection33) { Fabricate(:page, :parent => section3, :slug => 'subsection33', :title => 'subsection33') }
            let(:page331) { Fabricate(:page, :parent => subsection33, :slug => 'page331', :title => 'page331') }
        let(:page4) { Fabricate(:page, :parent => locale, :slug => 'page4', :title => 'page4')}
        let(:page5) { Fabricate(:page, :parent => locale, :slug => 'page5', :title => 'page5')}

        let(:build_site) { page111; page112; page11; section2; page311; page321; page331; page4; page5 }

    before do
      build_site
    end

    it {

    }
  end
end

# == Schema Information
#
# Table name: parts
#
#  id                        :integer         not null, primary key
#  html_content_id           :integer
#  created_at                :datetime
#  updated_at                :datetime
#  region                    :string(255)
#  type                      :string(255)
#  node_id                   :integer
#  navigation_level          :integer
#  navigation_selected_level :integer
#  navigation_from_id        :integer
#

