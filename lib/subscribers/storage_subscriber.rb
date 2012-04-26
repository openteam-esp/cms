class StorageSubscriber
  def update_content(info_path)
    HtmlPart.where(:html_info_path => info_path).map(&:index)
    TextPart.where(:text_info_path => info_path).map(&:index)
  end
end
