class Permission < ActiveRecord::Base
  attr_accessible :context, :role
  sso_auth_permission :roles => [:manager, :operator]
end

# == Schema Information
#
# Table name: permissions
#
#  context_id   :integer
#  context_type :string(255)
#  created_at   :datetime         not null
#  id           :integer          not null, primary key
#  role         :string(255)
#  updated_at   :datetime         not null
#  user_id      :integer
#

