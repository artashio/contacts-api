require 'spec_helper'
require 'rack/test'

RSpec.describe WebSocketController do
  include Rack::Test::Methods

  def app
    WebSocketController
  end

  describe 'GET /ws' do
    context 'when not a websocket request' do
      it 'returns 400 and error message' do
        get '/ws'

        expect(last_response.status).to eq(400)
        expect(last_response.body).to eq('Not a WebSocket request')
      end
    end
  end
end