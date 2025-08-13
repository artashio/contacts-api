require 'spec_helper'
require_relative '../../models/contact'
require_relative '../../models/contact_history'

RSpec.describe Contact, type: :model do
  before(:each) do
    ContactHistory.destroy_all
    Contact.destroy_all
  end

  it 'is valid with valid attributes' do
    contact = Contact.new(
      first_name: 'Jane',
      last_name: 'Doe',
      email: 'jane@example.com',
      phone: '1234567890'
    )
    expect(contact).to be_valid
  end

  it 'is invalid without required attributes' do
    contact = Contact.new
    expect(contact).not_to be_valid
    expect(contact.errors[:first_name]).to be_present
    expect(contact.errors[:last_name]).to be_present
    expect(contact.errors[:email]).to be_present
    expect(contact.errors[:phone]).to be_present
  end

  it 'validates uniqueness of email' do
    Contact.create!(
      first_name: 'Jane',
      last_name: 'Doe',
      email: 'jane@example.com',
      phone: '1234567890'
    )
    duplicate = Contact.new(
      first_name: 'John',
      last_name: 'Smith',
      email: 'jane@example.com',
      phone: '0987654321'
    )
    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:email]).to include('has already been taken')
  end

  it 'has many contact_histories' do
    assoc = described_class.reflect_on_association(:contact_histories)
    expect(assoc.macro).to eq(:has_many)
  end

  describe 'after_commit :broadcast_change' do
    it 'calls broadcast_change on update' do
      contact = Contact.create!(
        first_name: 'Jane',
        last_name: 'Doe',
        email: 'jane@example.com',
        phone: '1234567890'
      )
      allow(WebSocketHandler).to receive(:connections).and_return([double('ws', send: true)])
      expect_any_instance_of(Contact).to receive(:broadcast_change)
      contact.update(first_name: 'Janet')
    end

    it 'sends a message to all websocket connections on update' do
      ws_double = double('ws')
      expect(ws_double).to receive(:send).with(/contact_updated/)
      allow(WebSocketHandler).to receive(:connections).and_return([ws_double])

      contact = Contact.create!(
        first_name: 'Jane',
        last_name: 'Doe',
        email: 'jane@example.com',
        phone: '1234567890'
      )
      contact.update(first_name: 'Janet')
    end
  end
end