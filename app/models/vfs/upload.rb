class Upload < Inode
  belongs_to :folder
  before_create :set_type

  validates_presence_of :folder

  upload_accessor :file do
    storage_path { "#{I18n.l Date.today, :format => "%Y/%m/%d"}/#{Time.now.to_i}-#{file_name}"}
  end

  private

    def set_type
      mime_group = file_mime_type.to_s.split('/')[0]
      self.type = %w[audio video image].include?(mime_group) ? mime_group.classify : 'Attachment'
    end

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

