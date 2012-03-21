Fabricator(:locale) do
  slug    'ru'
  parent! { Fabricate :site }
  template 'main_page'

  context_id { |locale| locale.parent.context_id }
end
