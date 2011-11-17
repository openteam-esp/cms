Fabricator(:news_list_part) do
  news_channel 'channel'
  news_order_by 'since_desc'
  news_per_page 2
end

