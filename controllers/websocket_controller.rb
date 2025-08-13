require 'sinatra/base'
require_relative '../services/websocket_handler'

class WebSocketController < Sinatra::Base
  set :show_exceptions, false

  get '/ws' do
    result = WebSocketHandler.call(env)
    if result.is_a?(Array)
      halt result[0], result[2].join
    else
      result
    end
  end
end
