Settings.read(Rails.root.join('config', 'settings.yml'))

Settings.defaults Settings.extract!(Rails.env)[Rails.env] || {}
Settings.extract!(:test, :development, :production)

Settings.define 'hoptoad.api_key',            :env_var => 'HOPTOAD_API_KEY'
Settings.define 'hoptoad.host',               :env_var => 'HOPTOAD_HOST'

Settings.define 's3.access_key_id',           :env_var => 'S3_ACCESS_KEY_ID'
Settings.define 's3.secret_access_key',       :env_var => 'S3_SECRET_ACCESS_KEY'
Settings.define 's3.bucket_name',             :env_var => 'S3_BUCKET_NAME'

Settings.define 'blue_pages.host',            :env_var => 'BLUE_PAGES_HOST'
Settings.define 'blue_pages.protocol',        :env_var => 'BLUE_PAGES_PROTOCOL'
Settings.define 'blue_pages.port',            :env_var => 'BLUE_PAGES_PORT'

Settings.define 'appeals.host',               :env_var => 'APPEALS_HOST'
Settings.define 'appeals.protocol',           :env_var => 'APPEALS_PROTOCOL'
Settings.define 'appeals.port',               :env_var => 'APPEALS_PORT'

Settings.define 'news.host',                  :env_var => 'NEWS_HOST'
Settings.define 'news.protocol',              :env_var => 'NEWS_PROTOCOL'
Settings.define 'news.port',                  :env_var => 'NEWS_PORT'

Settings.define 'el_vfs.host',                :env_var => 'EL_VFS_HOST'
Settings.define 'el_vfs.protocol',            :env_var => 'EL_VFS_PROTOCOL'
Settings.define 'el_vfs.port',                :env_var => 'EL_VFS_PORT'

Settings.resolve!
