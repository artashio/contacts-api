require 'sinatra/base'

require 'json'
require_relative '../models/contact'
require_relative '../models/contact_history'
require_relative '../services/websocket_handler'

class ContactsController < Sinatra::Base
  set :show_exceptions, false

  post '/contacts' do
    data = JSON.parse(request.body.read)
    contact = Contact.new(data)
    if contact.save
      status 201
      contact.to_json
    else
      status 422
      contact.errors.full_messages.first
    end
  end

  get '/contacts' do
    Contact.all.to_json
  end

  get '/contacts/:id' do
    contact = Contact.find_by(id: params[:id])
    if contact
      contact.to_json
    else
      status 404
      {error: 'Not found'}.to_json
    end
  end

  put '/contacts/:id' do
    contact = Contact.find_by(id: params[:id])
    if contact
      previous = contact.attributes
      data = JSON.parse(request.body.read)
      ActiveRecord::Base.transaction do
        if contact.update(data)
          ContactHistory.create(
            contact_id: contact.id,
            diff: previous.to_json
          )
          contact.to_json
        else
          status 422
          contact.errors.full_messages.first
        end
      end
      else
        status 404
        {error: 'Not found'}.to_json
      end
  end

  delete '/contacts/:id' do
    contact = Contact.find_by(id: params[:id])
    if contact
      ContactHistory.where(contact_id: contact.id).destroy_all

      contact.destroy
  # WebSocketService.broadcast_update({action: 'delete', id: params[:id]})
      status 204
    else
      status 404
      {error: 'Not found'}.to_json
    end
  end

  get '/contacts/:id/history' do
    contact = Contact.find_by(id: params[:id])
    if contact
      contact.contact_histories.to_json
    else
      status 404
      {error: 'Not found'}.to_json
    end
  end
end
