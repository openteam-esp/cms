Fabricator(:text_part) do
  node! { Fabricate(:page) }
  region 'region'
  text_info_path '/ru/text/part/path'
end
