Settings.read(Rails.root.join('config', 'settings.yml'))

Settings.defaults Settings.extract!(Rails.env)[Rails.env] || {}
Settings.extract!(:test, :development, :production)

Settings.define 'hoptoad.api_key',            :env_var => 'HOPTOAD_API_KEY'
Settings.define 'hoptoad.host',               :env_var => 'HOPTOAD_HOST'

Settings.define 'blue_pages.url',             :env_var => 'BLUE_PAGES_URL'
Settings.define 'appeals.url',                :env_var => 'APPEALS_URL'
Settings.define 'news.url',                   :env_var => 'NEWS_URL'

Settings.resolve!
