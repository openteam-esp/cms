class Upload < ActiveRecord::Base
  before_create :set_type
  upload_accessor :file do
    storage_path { "#{I18n.l Date.today, :format => "%Y/%m/%d"}/#{Time.now.to_i}-#{file_name}"}
  end

  private

    def set_type
      mime_group = file_mime_type.to_s.split('/')[0]
      self.type = %w[audio video image].include?(mime_group) ? mime_group.classify : 'Attachment'
    end

end
