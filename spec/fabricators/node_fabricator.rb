Fabricator(:node) do
  title "MyString"
  slug { SecureRandom.base64.gsub(/[^[:alpha:]]/, '') }
  context!
  template 'main_page'
end
