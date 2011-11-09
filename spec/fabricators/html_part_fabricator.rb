Fabricator(:html_part) do
  body "MyText"
  node! { Fabricate(:page) }
  region 'region'
end
