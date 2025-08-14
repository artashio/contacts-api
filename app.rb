require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require_relative './controllers/contacts_controller'
require_relative './controllers/websocket_controller'
require_relative './models/contact'
require_relative './models/contact_history'

db = ENV['RACK_ENV'] == 'test' ? "contacts_test.db" : "contacts.db"

set :server, :puma
set :port, 4000
set :database, {adapter: 'sqlite3', database: db}

use ContactsController
use WebSocketController
