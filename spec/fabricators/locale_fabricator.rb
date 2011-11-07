Fabricator(:locale) do
  slug    'ru'
  parent! { Fabricate :site }
end
