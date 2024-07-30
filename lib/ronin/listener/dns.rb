# frozen_string_literal: true
#
# ronin-listener-dns - A DNS server for receiving exfiltrated data.
#
# Copyright (c) 2023-2024 Hal Brodigan (postmodern.mod3@gmail.com)
#
# ronin-listener-dns is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-listener-dns is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-listener-dns.  If not, see <https://www.gnu.org/licenses/>.
#

require_relative 'dns/server'

module Ronin
  module Listener
    #
    # Top-level methods for {Ronin::Listener::DNS}.
    #
    module DNS
      #
      # Starts the DNS listener server.
      #
      # @param [String] domain
      #   The domain to accept queries for (ex: `example.com`).
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for {Server#initialize}.
      #
      # @option kwargs [String] :host ('0.0.0.0')
      #   The interface to listen on.
      #
      # @option kwargs [Integer] :port (53)
      #   The local port to listen on.
      #
      # @yield [query_type,query_name]
      #   The given block will be passed each received query.
      #
      # @yieldparam [:A, :AAAA, :ANY, :CNAME, :HINFO, :LOC, :MINFO, :MX, :NS, :PTR, :SOA, :SRV, :TXT, :WKS] query_type
      #   The type of the query.
      #
      # @yieldparam [String] query_name
      #   The hostname being queried.
      #
      # @raise [ArgumentError]
      #   No callback block was given.
      #
      # @example
      #   Ronin::Listener::DNS.listen('0.0.0.0',53) do |query_type,query_name|
      #     puts "Received query #{query_type} #{query_name}"
      #   end
      #
      def self.listen(domain,**kwargs,&callback)
        server = Server.new(domain,**kwargs,&callback)
        server.run
      end
    end
  end
end
