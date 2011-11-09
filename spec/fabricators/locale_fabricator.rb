Fabricator(:locale) do
  slug    'ru'
  parent! { Fabricate :site }
  template 'template'
end
