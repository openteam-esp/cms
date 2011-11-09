Fabricator(:page) do
  title "MyString"
  slug "name"
  parent! { Fabricate :locale }
  template 'template'
end
