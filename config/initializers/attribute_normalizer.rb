AttributeNormalizer.configure do |config|

  SANITIZE_CONFIG  = Sanitize::Config::RELAXED
  SANITIZE_CONFIG[:elements] += %w[audio video div]
  SANITIZE_CONFIG[:attributes]['a'] << 'target'
  SANITIZE_CONFIG[:attributes]['audio'] = %w[controls src]
  SANITIZE_CONFIG[:attributes]['video'] = %w[controls src width height]
  SANITIZE_CONFIG[:attributes][:all] += %w[style class]
  SANITIZE_CONFIG[:output] = :xhtml

  config.normalizers[:sanitize] = ->(value, options) do
    Sanitize.clean(value, SANITIZE_CONFIG).to_s.gsub(%r{<a(.*?)>\n<img(.*?) />\n</a>}, '<a\1><img\2 /></a>')
  end

  html_formatter = Gilenson.new
  html_formatter.glyph = Gilenson::GLYPHS.inject({}) do | hash, pair | hash[pair.first] = "&#{pair.first};"; hash end
  html_formatter.glyph[:nob_open] = Gilenson::GLYPHS[:nob_open]
  html_formatter.glyph[:nob_close] = Gilenson::GLYPHS[:nob_close]

  config.normalizers[:gilensize_as_text] = ->(value, options) do
    Sanitize.clean(value.to_s.gilensize(:html => false, :raw_output => true)).gsub(/^[[:space:]]+/, '').squish
  end

  config.normalizers[:gilensize_as_html] = ->(value, options) do
    html_formatter.process value
  end

  config.normalizers[:as_array_of_integer] = ->(value, options) do
    value.reject { |e| e.blank? }.map(&:to_i)
  end

  config.normalizers[:truncate] = ->(value, options) do
    options.reverse_merge!(:length => 30, :omission => nil)
    l = options[:length] - options[:omission].to_s.mb_chars.length
    chars = value.mb_chars
    (chars.length > options[:length] ? "#{chars[0...l]}#{options[:omission]}" : value).to_s
  end
end
