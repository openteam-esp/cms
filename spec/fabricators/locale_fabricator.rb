Fabricator(:locale) do
  slug    'ru'
  parent! { Fabricate :site }
  template 'application'
  context!
end
