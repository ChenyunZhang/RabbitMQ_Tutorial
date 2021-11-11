require 'bunny'

# docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3.9-management
# run the server 

# we can connect toa broker on a differnet machine, by sprcify its name or IP address using the :hostname option.
# example: Bunny.new(hostname: 'rabbit.local')
connection = Bunny.new
connection.start

# create  channel
channel = connection.create_channel

# initialize a queue, so we can send/publish messages.
queue = channel.queue("hello")
channel.default_exchange.publish("test2", routing_key: queue.name)
puts " [x] Sent 'Hello World'"

connection.close