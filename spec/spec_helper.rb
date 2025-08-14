ENV['RACK_ENV'] ||= 'test'

require 'rack/test'
require 'rspec'
require File.expand_path('../app.rb', __dir__)

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:each) do
    ContactHistory.destroy_all
    Contact.destroy_all
  end

end

def app
  Sinatra::Application
end