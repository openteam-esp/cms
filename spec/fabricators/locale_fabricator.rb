Fabricator(:locale) do
  slug    'ru'
  parent! { Fabricate :site }
  template 'application'

  context_id { |locale| locale.parent.context_id }
end
