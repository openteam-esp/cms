Fabricator(:html_part) do
  node! { Fabricate(:page) }
  region 'region'
  html_info_path '/ru/ololo'
end
