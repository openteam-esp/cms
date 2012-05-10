Fabricator(:documents_item_part) do
  template 'template'
  node! { Fabricate :page }
  region 'context'
  documents_contexts { [1] }
end

