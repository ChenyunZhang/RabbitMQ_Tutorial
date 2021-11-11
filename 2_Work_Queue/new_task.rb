# This program will schedule tasks to our work queue

require "bunny"

connection = Bunny.new
connection.start

channel = connection.create_channel
queue = channel.queue("take_queue",durable: true)

message = ARGV.empty? ? "Hello World" : ARGV.join(' ')

# after set durable to true, we want to mark persistence to true as well, because now RabbitMQ won't lost message even when it's restarted.
queue.publish(message, persistent: true)
puts " [x] Sent #{message}"

connection.close