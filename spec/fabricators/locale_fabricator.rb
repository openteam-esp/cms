Fabricator(:locale) do
  slug    'ru'
  parent! { Fabricate :site }
  template 'main_page'
end
