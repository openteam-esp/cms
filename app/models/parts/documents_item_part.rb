class DocumentsItemPart < Part
  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    request_body.tap do |paper|
      paper['asserted_projects']  = change_ids_to_links(paper['asserted_projects'])
      paper['canceled_documents'] = change_ids_to_links(paper['canceled_documents'])
      paper['changed_documents']  = change_ids_to_links(paper['changed_documents'])
    end
  end

  private
    def documents_url
      "#{Settings['documents.url']}"
    end

    def request
      @request ||= Restfulie.at("#{documents_url}/papers/#{paper_id}").accepts("application/json").get
    end

    def request_body
      ActiveSupport::JSON.decode(request.body).tap { |hash| hash.delete('id') }
    end

    def paper_id
      params.try(:[], 'id')
    end

    def change_ids_to_links(papers)
      if papers
        papers.map { |p| p.merge!('link' => "#{node.route_without_site}?parts_params[documents_item][id]=#{p['id']}") }
        papers.each { |p| p.delete('id') }
      else
        []
      end
    end
end
