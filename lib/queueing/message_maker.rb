require 'bunny'

class MessageMaker
  def self.make_message(queue_name, message)
    amqp_client = Bunny.new(:logging => false)

    amqp_client.start

    exchange = amqp_client.exchange('esp', :type => :topic)

    queue = amqp_client.queue(queue_name, :durable => true)

    exchange.publish(message, :key => queue.name)

    amqp_client.stop
  end
end
