User.find_or_initialize_by_uid('1').tap do | user |
  user.save(:validate => false)
  user.permissions << Permission.new(:role => :manager)
end
