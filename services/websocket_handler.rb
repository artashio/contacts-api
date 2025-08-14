require 'faye/websocket'

module WebSocketHandler
  def self.connections
    @connections ||= []
  end

  def self.call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env)

      ws.on :open do |_event|
        connections << ws
      end

      ws.on :close do |_event|
        connections.delete(ws)
      end

      ws.rack_response
    else
      [400, { 'Content-Type' => 'text/plain' }, ['Not a WebSocket request']]
    end
  end
end
