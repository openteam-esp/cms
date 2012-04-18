require 'bunny'

class MessageMaker
  SUCCESS_QUEUE = 'esp.cms.updated.page'

  def self.make_message(message)
    amqp_client = Bunny.new(:logging => false)
    amqp_client.start
    queue = amqp_client.queue(SUCCESS_QUEUE, :durable => true)
    direct_exchange = amqp_client.exchange('');
    direct_exchange.publish(message, :key => queue.name, :persistent => true)
    amqp_client.stop
  end
end
