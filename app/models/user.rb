class User < ActiveRecord::Base
  sso_auth_user

  attr_accessible :description, :email, :first_name, :last_name, :location, :name, :nickname, :phone
end

# == Schema Information
#
# Table name: users
#
#  created_at         :datetime         not null
#  current_sign_in_at :datetime
#  current_sign_in_ip :string(255)
#  description        :text
#  email              :text
#  first_name         :text
#  id                 :integer          not null, primary key
#  image              :text
#  last_name          :text
#  last_sign_in_at    :datetime
#  last_sign_in_ip    :string(255)
#  location           :text
#  name               :text
#  nickname           :text
#  phone              :text
#  raw_info           :text
#  sign_in_count      :integer
#  uid                :string(255)
#  updated_at         :datetime         not null
#  urls               :text
#

