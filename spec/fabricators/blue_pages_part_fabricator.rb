Fabricator(:blue_pages_part) do
  node! { Fabricate(:page) }
  region 'content_first'
end

