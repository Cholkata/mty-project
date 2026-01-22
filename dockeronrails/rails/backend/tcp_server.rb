# frozen_string_literal: true

require "socket"
require "logger"

HOST = ENV.fetch("HOST", "0.0.0.0")
PORT = Integer(ENV.fetch("PORT", 4000))

logger = Logger.new($stdout)
logger.level = Logger::INFO

server = TCPServer.new(HOST, PORT)
logger.info "TCP server listening on #{HOST}:#{PORT}"

running = true

# Graceful shutdown
Signal.trap("TERM") { running = false }
Signal.trap("INT")  { running = false }

while running
  begin
    socket = server.accept_nonblock
  rescue IO::WaitReadable
    IO.select([server])
    retry
  end

  Thread.new(socket) do |client|
    begin
      logger.info "Client connected: #{client.peeraddr[2]}"

      while (line = client.gets)
        line.strip!
        logger.info "Received: #{line}"

        # Echo response (replace with your logic)
        client.puts "ACK: #{line}"
      end
    rescue => e
      logger.error "Client error: #{e.message}"
    ensure
      client.close
      logger.info "Client disconnected"
    end
  end
end

logger.info "Shutting down TCP server"
server.close

