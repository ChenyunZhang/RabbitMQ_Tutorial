require "bunny"

connection = Bunny.new(automatically_recover: false)
connection.start

channel = connection.create_channel
# make sure the param inside is same as the queue() in send.rb
queue = channel.queue("hello")

begin
    puts " [*] Waiting for messages. To exit press CTRL+C"
    # block: true is only used to keep the main thread
    # alive. Please avoid using it in real world applications.
    queue.subscribe(block: true) do |_delivery_info, _properties, body|
        puts " [*] Received #{body}"
    end
rescue Interrupt => _
    connection.close

    exit(0)
end