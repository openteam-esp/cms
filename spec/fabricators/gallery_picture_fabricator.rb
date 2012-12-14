Fabricator(:gallery_picture) do
  gallery_part!
  description 'Nize fotochka'
  picture_url 'http://storage.esp.url/files/1.png'
end

# == Schema Information
#
# Table name: gallery_pictures
#
#  created_at      :datetime         not null
#  description     :text
#  gallery_part_id :integer
#  id              :integer          not null, primary key
#  picture_url     :string(255)
#  position        :integer
#  updated_at      :datetime         not null
#

