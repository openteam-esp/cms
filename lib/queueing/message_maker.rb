require 'bunny'

class MessageMaker
  def self.make_message(routing_key, message)
    amqp_client = Bunny.new(:logging => false)

    amqp_client.start

    exchange = amqp_client.exchange('esp.exchange', :type => :topic)

    queue = amqp_client.queue('esp.queue', :durable => true)

    exchange.publish(message, :key => routing_key, :persistent => true)

    amqp_client.stop
  end
end
