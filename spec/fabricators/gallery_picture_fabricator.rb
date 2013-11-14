Fabricator(:gallery_picture) do
  gallery_part!
  description 'Nize fotochka'
  picture_url 'http://storage.esp.url/files/1.png'
end

# == Schema Information
#
# Table name: gallery_pictures
#
#  id              :integer          not null, primary key
#  gallery_part_id :integer
#  description     :text
#  picture_url     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  position        :integer
#

