require_relative '../services/websocket_handler'

class Contact < ActiveRecord::Base
  validates :first_name, :last_name, :email, :phone, presence: true
  validates :email, uniqueness: true
  has_many :contact_histories

  before_update :prevent_update_if_unchanged

  after_commit :broadcast_change, on: [:create, :update, :destroy]

  private

   def prevent_update_if_unchanged
    if !changed?
      errors.add(:base, "No changes.")
      throw(:abort)
    end
  end

  def broadcast_change
    message = { type: "new_contact_event" }.to_json
    WebSocketHandler.connections.each { |conn| conn.send(message) }
  end
end