A producer is a user application that sends messages.
A queue is a buffer that stores messages.
A consumer is a user application that receives messages.


producer can only send message to exchange.
exchange receives message from producer, and pushes the message to queues
exchange => how to deal with the message received from the producer depends on exchange types.
exchange types: direct, topic, headers and fanout
