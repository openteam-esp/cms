Fabricator(:gallery_part) do
  node! { Fabricate(:page) }
  region 'region'
end
