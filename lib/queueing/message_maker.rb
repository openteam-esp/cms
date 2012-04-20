require 'bunny'

class MessageMaker
  def self.make_message(queue, message)
    amqp_client = Bunny.new(:logging => false)
    amqp_client.start
    queue = amqp_client.queue(queue, :durable => true)
    direct_exchange = amqp_client.exchange('');
    direct_exchange.publish(message, :key => queue.name, :persistent => true)
    amqp_client.stop
  end
end
