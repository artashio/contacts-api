require 'spec_helper'
require 'rack/test'

RSpec.describe ContactsController do
  include Rack::Test::Methods

  def app
    ContactsController
  end

  before(:each) do
    ContactHistory.destroy_all
    Contact.destroy_all
  end

  describe 'POST /contacts' do
    it 'creates a new contact' do
      post '/contacts', {
        first_name: 'John',
        last_name: 'Doe',
        email: 'john@example.com',
        phone: '1234567890'
      }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq(201)
      expect(JSON.parse(last_response.body)['email']).to eq('john@example.com')
    end

    it 'returns error for missing fields' do
      post '/contacts', { first_name: 'Jane' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq(422)
      expect(last_response.body).to be_a(String)
    end
  end

  describe 'GET /contacts' do
    it 'returns all contacts' do
      Contact.create!(first_name: 'A', last_name: 'B', email: 'a@b.com', phone: '1')
      get '/contacts'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to be_an(Array)
    end
  end

  describe 'GET /contacts/:id' do
    it 'returns a contact by id' do
      contact = Contact.create!(first_name: 'A', last_name: 'B', email: 'a@b.com', phone: '1')
      get "/contacts/#{contact.id}"
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['id']).to eq(contact.id)
    end

    it 'returns 404 for missing contact' do
      get '/contacts/99999'
      expect(last_response.status).to eq(404)
    end
  end

  describe 'PUT /contacts/:id' do
    it 'updates a contact' do
      contact = Contact.create!(first_name: 'A', last_name: 'B', email: 'a@b.com', phone: '1')
      put "/contacts/#{contact.id}", { first_name: 'Updated' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['first_name']).to eq('Updated')
    end

    it 'returns 404 for missing contact' do
      put '/contacts/99999', { first_name: 'Updated' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq(404)
    end
  end

  describe 'DELETE /contacts/:id' do
    it 'deletes a contact' do
      contact = Contact.create!(first_name: 'A', last_name: 'B', email: 'a@b.com', phone: '1')
      delete "/contacts/#{contact.id}"
      expect(last_response.status).to eq(204)
    end

    it 'returns 404 for missing contact' do
      delete '/contacts/99999'
      expect(last_response.status).to eq(404)
    end
  end

  describe 'GET /contacts/:id/history' do
    it 'returns contact history' do
      contact = Contact.create!(first_name: 'A', last_name: 'B', email: 'a@b.com', phone: '1')
      get "/contacts/#{contact.id}/history"
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to be_an(Array)
    end

    it 'returns 404 for missing contact' do
      get '/contacts/99999/history'
      expect(last_response.status).to eq(404)
    end
  end
end