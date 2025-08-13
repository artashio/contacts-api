require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require_relative './controllers/contacts_controller'
require_relative './controllers/websocket_controller'
require_relative './models/contact'
require_relative './models/contact_history'

set :server, :puma
set :port, 4000
set :database, {adapter: 'sqlite3', database: 'contacts.db'}

use ContactsController
use WebSocketController
