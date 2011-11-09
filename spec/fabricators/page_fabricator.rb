Fabricator(:page) do
  title "MyString"
  slug "name"
  parent! { Fabricate :locale }
  template 'application'
end
