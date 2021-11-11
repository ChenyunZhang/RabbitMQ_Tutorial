# This work queue will be used to distrubte time-consuming tasks among multiple workers
# aka Task Queue
# https://www.rabbitmq.com/tutorials/tutorial-two-ruby.html
# A timeout (30 minutes by default) is enforced on consumer delivery acknowledgement. 
# Message acknowledgments are turned off by default.
require "bunny"

connection = Bunny.new
connection.start

channel = connection.create_channel
# set durable: true, so we can make sure that queue will survive a RabbitMQ node restart. 
# PRECONDITION_FAILED - inequivalent arg 'durable' for queue 'key' in vhost '/': received 'true' but current is 'false'
# Since I start the queue with key, adding durable to be true would trigger above error
# RabbitMQ doesn't allow you to redefine an existing queue with different parameters and will return an error to any program that tries to do that.
# simple change the first arguement to something else, change both to get rid of the error.
queue = channel.queue("take_queue",durable: true)

n=1
# this tells Rmq that don't send more than one (n) message to a worker at a time
channel.prefetch(n)
puts ' [*] Waiting for messages. To exit press CTRL+C'
# manual_ack: true to turn message acknlowledgments on.
# this will make sure the message will not be lost, even when worker is killed.

begin
    queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
      puts " [x] Received '#{body}'"
      # imitate some work
      sleep body.count('.').to_i
      puts ' [x] Done'
      channel.ack(delivery_info.delivery_tag)
    end
  rescue Interrupt => _
    connection.close
  end


#   Using message acknowledgments and prefetch you can set up a work queue. The durability options let the tasks survive even if RabbitMQ is restarted.