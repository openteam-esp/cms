class PriemSubscriber
  def add(message)
    send_reindex_show('add', message['url'])
    send_reindex_lists(message)
  end

  def remove(message)
    send_reindex_show('remove', message['url'])
    send_reindex_lists(message)
  end

  private
    def send_reindex_lists(message)
      parts = PriemPart.where("priem_kinds like ?", "%#{message['kind']}%")
        .where('priem_forms like ?', "%#{message['training_form']}%")
        .where("priem_context_kind is null or priem_context_kind = '' or
                (priem_context_kind = ? and priem_context_id = ?) or
                (priem_context_kind = ? and priem_context_id = ?)",
                'faculty', message['faculty'], 'subfaculty', message['subfaculty'])
      parts.select(&:indexable?).each do |priem_part|
        MessageMaker.make_message 'esp.cms.searcher', 'add', priem_part.node.url
      end
    end

    def send_reindex_show(command, url)
      MessageMaker.make_message 'esp.cms.searcher', command, url
    end
end
