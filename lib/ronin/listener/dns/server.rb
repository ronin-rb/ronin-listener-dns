# frozen_string_literal: true
#
# ronin-listener-dns - A DNS server for receiving exfiltrated data.
#
# Copyright (c) 2023 Hal Brodigan (postmodern.mod3@gmail.com)
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

require 'async/dns'

module Ronin
  module Listener
    module DNS
      #
      # A simple DNS server for receiving exfiltrated DNS queries.
      #
      class Server < Async::DNS::Server

        # The domain to accept queries for.
        #
        # @return [String]
        attr_reader :domain

        # The host the server will listen on.
        #
        # @return [String]
        attr_reader :host

        # The port the server will listen on.
        #
        # @return [Integer]
        attr_reader :port

        # The callback which will be passed all received queries.
        #
        # @return [Proc]
        #
        # @api private
        attr_reader :callback

        #
        # Initializes the DNS listener server.
        #
        # @param [String] domain
        #   The domain to accept queries for (ex: `example.com`).
        #
        # @param [String] host
        #   The interface to listen on.
        #
        # @param [Integer] port
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
        def initialize(domain, host: '0.0.0.0', port: 53, &callback)
          unless callback
            raise(ArgumentError,"#{self.class}#initialize requires a callback block")
          end

          @domain = domain
          @suffix = ".#{domain}"

          @host = host
          @port = port

          super([[:udp, host, port]])

          @callback = callback
        end

        # Mapping of Resolv resource classes to Symbols.
        #
        # @api private
        RECORD_TYPES = {
          Resolv::DNS::Resource::IN::A     => :A,
          Resolv::DNS::Resource::IN::AAAA  => :AAAA,
          Resolv::DNS::Resource::IN::ANY   => :ANY,
          Resolv::DNS::Resource::IN::CNAME => :CNAME,
          Resolv::DNS::Resource::IN::HINFO => :HINFO,
          Resolv::DNS::Resource::IN::LOC   => :LOC,
          Resolv::DNS::Resource::IN::MINFO => :MINFO,
          Resolv::DNS::Resource::IN::MX    => :MX,
          Resolv::DNS::Resource::IN::NS    => :NS,
          Resolv::DNS::Resource::IN::PTR   => :PTR,
          Resolv::DNS::Resource::IN::SOA   => :SOA,
          Resolv::DNS::Resource::IN::SRV   => :SRV,
          Resolv::DNS::Resource::IN::TXT   => :TXT,
          Resolv::DNS::Resource::IN::WKS   => :WKS
        }

        #
        # Processes an incoming query.
        #
        # @param [String] name
        #   The query value (ex: `www.example.com`).
        #
        # @param [Class<Resolv::DNS::Resource>] resource_class
        #   The resource class (ex: `Resolv::DNS::Resource::IN::A`).
        #
        # @param [Async::DNS::Transaction] transaction
        #   The DNS transaction object.
        #
        # @api private
        #
        def process(name,resource_class,transaction)
          # filter out queries for all other domains
          if name.end_with?(@suffix)
            # map the `Resolv::DNS::Resource::IN` class to a Symbol
            query_type = RECORD_TYPES.fetch(resource_class)

            @callback.call(query_type,name)
          end

          # always respond with an error to prevent DNS caching
          transaction.fail!(:NXDomain)
        end

      end
    end
  end
end
