Fabricator(:page) do
  title "MyString"
  slug "name"
  parent! { Fabricate :locale }
  template 'inner_page'

  context_id { |page| page.parent.context_id }
end
