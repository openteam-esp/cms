Settings.read(Rails.root.join('config', 'settings.yml'))

Settings.defaults Settings.extract!(Rails.env)[Rails.env] || {}
Settings.extract!(:test, :development, :production)

Settings.define 'hoptoad.api_key',            :env_var => 'HOPTOAD_API_KEY'
Settings.define 'hoptoad.host',               :env_var => 'HOPTOAD_HOST'

Settings.define 's3.access_key_id',           :env_var => 'S3_ACCESS_KEY_ID'
Settings.define 's3.secret_access_key',       :env_var => 'S3_SECRET_ACCESS_KEY'
Settings.define 's3.bucket_name',             :env_var => 'S3_BUCKET_NAME'

Settings.resolve!
