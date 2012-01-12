class DocumentsItemPart < Part
  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    request_body
  end

  private
    def documents_url
      "#{Settings['documents.url']}"
    end

    def request
      @request ||= Restfulie.at("#{documents_url}/papers/#{id}").accepts("application/json").get
    end

    def request_body
      ActiveSupport::JSON.decode(request.body).tap { |hash| hash.delete('id') }
    end

    def id
      params['id']
    end
end
