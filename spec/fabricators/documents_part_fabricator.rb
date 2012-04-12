Fabricator(:documents_part) do
  template 'template'
  node! { Fabricate :page }
  documents_kind 'documents'
  region 'context'
  documents_contexts { [1] }
end

