#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'ronin/listener/dns'

puts "Listening on 127.0.0.1:5553 for *.example.com ..."
puts "Try running `host -p 5553 s3cr3t.example.com 127.0.0.1` to test"
puts

begin
  Ronin::Listener::DNS.listen('example.com', host: '127.0.0.1', port: 5553) do |query_type,query_value|
    puts "Received query for #{query_type} #{query_value}"
  end
rescue Interrupt
  exit(127)
end
