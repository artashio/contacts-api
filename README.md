# Contacts API

A simple RESTful PUBLIC API for managing contacts, built with Sinatra and ActiveRecord.
Includes real-time updates via WebSocket.

## Prerequisites

- [homebrew](https://brew.sh/) (Optiona) package manager
- [Ruby](https://formulae.brew.sh/formula/ruby)
- [contact-client](https://github.com/artashio/contacts-client)
- [websocat](https://formulae.brew.sh/formula/websocat) (Optional) to access websocket cli

## Setup

1. **Install dependencies:**
   ```
   bundle install
   ```
2. **Set up the database:**
   ```
   bundle exec rake db:migrate
   ```
3. **Run the application:**
   ```
   ruby app.rb
   ```

## Usage

- **Base URL:** `http://localhost:4000`
- **API Endpoints:**
  - `GET /contacts` - Retrieve all contacts
  - `GET /contacts/:id` - Retrieve a specific contact
  - `POST /contacts` - Create a new contact
  - `PUT /contacts/:id` - Update a contact
  - `DELETE /contacts/:id` - Delete a contact

## Example: Update a Contact with cURL

```
curl -X PUT http://localhost:4000/contacts/<ID> \
   -H "Content-Type: application/json" \
   -d '{"first_name":"John","last_name":"Doe","email":"test@example.com","phone":"123567890"}'
```

## Tests

1. **Set up the test database:**
   ```
   bundle exec rake db:migrate RACK_ENV=test
   ```
2. **Run tests:**
   ```
   bundle exec rspec
   ```