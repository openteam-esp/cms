Fabricator(:news_item_part) do
  news_channel 'channel'
  node! { Fabricate(:page) }
  region 'content_first'
end

