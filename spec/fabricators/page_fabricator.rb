Fabricator(:page) do
  title "MyString"
  slug "name"
  parent! { Fabricate :locale }
  template 'inner_page'
end
