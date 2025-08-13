require 'spec_helper'

RSpec.describe ContactHistory, type: :model do
  it 'can be created with valid attributes' do
    contact = Contact.create!(
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@example.com',
      phone: '1234567890'
    )
    history = ContactHistory.create!(contact_id: contact.id, diff: {foo: 'bar'}.to_json)
    expect(history.contact).to eq(contact)
    expect(history.diff).to eq({foo: 'bar'}.to_json)
  end

  it 'belongs to a contact' do
    assoc = described_class.reflect_on_association(:contact)
    expect(assoc.macro).to eq(:belongs_to)
  end
end