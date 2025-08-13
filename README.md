# Contacts API

A simple RESTful API for managing contacts, built with Sinatra and ActiveRecord.
Includes real-time updates via WebSocket.

## Prerequisites

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

## Next Steps

- Add authentication and authorization
- Write unit and integration tests
