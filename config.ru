
# frozen_string_literal: true
require 'thin'
require_relative 'app'

run Sinatra::Application
