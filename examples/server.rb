#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'ronin/listener/dns'

puts "Listening on 127.0.0.1:5553 for *.example.com ..."
puts "Try running `host -p 5553 s3cr3t.example.com 127.0.0.1` to test"
puts

begin
  Ronin::Listener::DNS.listen('example.com', host: '127.0.0.1', port: 5553) do |query|
    puts "Received query for #{query.type} #{query.label} from #{query.source_addr.ip_address}:#{query.source_addr.ip_port}"
  end
rescue Interrupt
  exit(127)
end
