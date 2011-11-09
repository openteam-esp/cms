Fabricator(:html_part) do
  body "MyText"
  page! { Fabricate(:page) }
  region 'region'
end
