class Page < ActiveRecord::Base
  belongs_to :locale
  belongs_to :template
end
