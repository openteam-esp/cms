class DocumentsSubscriber
  def add(document_message)
    send_messages('add', document_message)
  end  

  def remove(document_message)
    send_messages('remove', document_message)
  end

  private
    def send_messages(kind, document_message)
      parts = DocumentsItemPart.where(:documents_kind => document_message['kind'].pluralize).select { |d| d.documents_contexts.include?(document_message['context_id'].to_i) }

      parts.each do |part|
        MessageMaker.make_message 'esp.cms.searcher', kind, part.document_url(document_message['id'])
      end
    end
end
