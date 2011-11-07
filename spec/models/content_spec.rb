# encoding: utf-8

require 'spec_helper'

describe Content do
  it { should normalize_attribute(:body).from('<script>alert("!");</script> ').to('alert("!");') }
  it { should normalize_attribute(:body).from('&quot;Русский&quot;').to('&laquo;Русский&raquo;') }
end

# == Schema Information
#
# Table name: contents
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

