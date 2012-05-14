Fabricator(:blue_pages_item_part) do
  node! { Fabricate(:page) }
  region 'content_first'
end

