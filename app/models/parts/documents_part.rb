# encoding: utf-8

class DocumentsPart < Part
  def to_json
    as_json(:only => :type, :methods => 'content')
  end

  def content
    { 'papers' => ActiveSupport::JSON.decode(request.body) }
  end

  def kind_of_papers
    'documents'
  end

  def request
    @request ||= Restfulie.at("#{documents_url}/#{kind_of_papers}").accepts("application/json").get
  end

  private
    def documents_url
      "#{Settings['documents.url']}"
    end
end
