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

require 'json'
require 'csv'

module Ronin
  module Listener
    module DNS
      #
      # Represents a received DNS query.
      #
      class Query

        # The desired record type.
        #
        # @return [:A, :AAAA, :ANY, :CNAME, :HINFO, :LOC, :MINFO, :MX, :NS, :PTR, :SOA, :SRV, :TXT, :WKS]
        attr_reader :type

        # The domain label (ex: `example.com` or `www.example.com`).
        #
        # @return [String]
        attr_reader :label

        alias name label

        # The remote IP address and port that sent the query.
        #
        # @return [Addrinfo]
        attr_reader :source_addr

        #
        # Initializes the query.
        #
        # @param [:A, :AAAA, :ANY, :CNAME, :HINFO, :LOC, :MINFO, :MX, :NS, :PTR, :SOA, :SRV, :TXT, :WKS] type
        #   The queried record type.
        #
        # @param [String] label
        #   The queried domain label.
        #
        # @param [Addrinfo] source_addr
        #   The remote IP address and port that sent the query.
        #
        # @api private
        #
        def initialize(type,label,source_addr)
          @type  = type
          @label = label

          @source_addr = source_addr
        end

        #
        # The source IP address that sent the query.
        #
        # @return [String]
        #
        def source_ip
          @source_addr.ip_address
        end

        #
        # The source port the query was sent from.
        #
        # @return [Integer]
        #
        def source_port
          @source_addr.ip_port
        end

        #
        # The source of the query.
        #
        # @return [String]
        #   The source IP:port pair as a String.
        #
        def source
          "#{source_ip}:#{source_port}"
        end

        #
        # Converts the query to a String.
        #
        # @return [String]
        #   The String containing the {#source}, {#type}, and {#label}.
        #
        def to_s
          "#{source} #{@type} #{@label}"
        end

        #
        # Converts the query into an Array.
        #
        # @return [(String, Integer, Symbol, String)]
        #   The {#source_ip}, {#source_port}, {#type}, and {#label}.
        #
        def to_a
          [source_ip, source_port, @type, @label]
        end

        #
        # Converts the query into a Hash.
        #
        # @return [Hash{Symbol => String,Integer,Symbol}]
        #   The Hash containing {#source_ip}, {#source_port}, {#type}, and
        #   {#label}.
        #
        def to_h
          {
            source_ip:   source_ip,
            source_port: source_port,
            type:        @type,
            label:       @label
          }
        end

        #
        # Converts the DNS query to a CSV row.
        #
        # @return [String]
        #   The CSV row.
        #
        def to_csv
          to_a.to_csv
        end

        alias as_json to_h

        #
        # Converts the DNS query into JSON.
        #
        # @param [Array] args
        #   Additional arguments for `Hash#to_json`.
        #
        # @return [String]
        #   The raw JSON string.
        #
        def to_json(*args)
          as_json.to_json(*args)
        end

      end
    end
  end
end
