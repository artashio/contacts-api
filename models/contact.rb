require_relative '../services/websocket_handler'

class Contact < ActiveRecord::Base
  after_commit :broadcast_change, on: [:create, :update, :destroy]

  validates :first_name, :last_name, :email, :phone, presence: true
  validates :email, uniqueness: true
  has_many :contact_histories

  private

  def broadcast_change
    message = { type: 'contact_updated', id: id, attributes: changes }.to_json
    WebSocketHandler.connections.each { |conn| conn.send(message) }
  end
end