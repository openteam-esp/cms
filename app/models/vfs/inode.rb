class Inode < ActiveRecord::Base
end
# == Schema Information
#
# Table name: inodes
#
#  id             :integer         not null, primary key
#  type           :string(255)
#  file_name      :string(255)
#  file_mime_type :string(255)
#  file_size      :string(255)
#  file_uid       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  folder_id      :string(255)
#  ancestry       :string(255)
#
