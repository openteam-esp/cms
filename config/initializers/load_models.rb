Dir[Rails.root.join('app/models/parts/*.rb')].each do | file |
  require_or_load file
end if Rails.env.development?
