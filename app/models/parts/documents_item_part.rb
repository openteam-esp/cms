class DocumentsItemPart < Part
  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
  end
  private
    def documents_url
      "#{Settings['documents.url']}"
    end


    def request
    end
end
