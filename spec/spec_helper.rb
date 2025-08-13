ENV['RACK_ENV'] ||= 'test'

require 'rack/test'
require 'rspec'
require File.expand_path('../app.rb', __dir__) # adjust if your main app file is not app.rb
RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:each) do
    # Clear the database or reset state before each test if necessary
    ContactHistory.destroy_all
    Contact.destroy_all
  end

end

def app
  Sinatra::Application
end