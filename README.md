# ronin-listener-dns

[![CI](https://github.com/ronin-rb/ronin-listener-dns/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-listener-dns/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-listener-dns.svg)](https://codeclimate.com/github/ronin-rb/ronin-listener-dns)

* [Website](https://ronin-rb.dev/)
* [Source](https://github.com/ronin-rb/ronin-listener-dns)
* [Issues](https://github.com/ronin-rb/ronin-listener-dns/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-listener-dns)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

## Description

ronin-listener-dns is a DNS server for receiving exfiltrated data sent via DNS
queries. ronin-listener-dns can be used to test for XML external entity (XXE)
injection.

## Features

* Supports receiving any DNS query for a given domain.
* Always returns with `NXDOMAIN` to prevent DNS caching.

## Examples

```ruby
require 'ronin/listener/dns'

Ronin::Listener::DNS.listen('example.com', host: '127.0.0.1', port: 5553) do |query|
  puts "Received query for #{query.type} #{query.label} from #{query.source}"
end
```

Then try running `host -p 5553 s3cr3t.example.com 127.0.0.1` to test the server.

```
Received query for A s3cr3t.example.com from 127.0.0.1:59042
```

**Note:** if you wish to run the server on `0.0.0.0` and port `53`, the ruby
script must be ran as `root`.

## Requirements

* [Ruby] >= 3.0.0
* [async-dns] ~> 1.0

## Install

```shell
$ gem install ronin-listener-dns
```

### Gemfile

```ruby
gem 'ronin-listener-dns', '~> 0.1'
```

### gemspec

```ruby
gem.add_dependency 'ronin-listener-dns', '~> 0.1'
```

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin-listener-dns/fork)
2. Clone It!
3. `cd ronin-listener-dns/`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code It!
7. `bundle exec rake spec`
8. `git push origin my_feature`

## License

Copyright (c) 2023 Hal Brodigan (postmodern.mod3@gmail.com)

ronin-listener-dns is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ronin-listener-dns is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with ronin-listener-dns.  If not, see <https://www.gnu.org/licenses/>.

[Ruby]: https://www.ruby-lang.org
[async-dns]: https://github.com/socketry/async-dns#readme
