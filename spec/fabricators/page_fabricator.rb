Fabricator(:page) do
  title "MyString"
  slug "name"
  parent! { Fabricate(:site).locales.first }
  template! { Fabricate(:template) }
end
