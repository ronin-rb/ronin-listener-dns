# ronin-exfil-dns

[![CI](https://github.com/ronin-rb/ronin-exfil-dns/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-exfil-dns/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-exfil-dns.svg)](https://codeclimate.com/github/ronin-rb/ronin-exfil-dns)

* [Website](https://ronin-rb.dev/)
* [Source](https://github.com/ronin-rb/ronin-exfil-dns)
* [Issues](https://github.com/ronin-rb/ronin-exfil-dns/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-exfil-dns)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

## Description

ronin-exfil-dns is a DNS server for receiving exfiled data sent via DNS queries.
ronin-exfil-dns can be used to test for XML external entity (XXE) injection.

## Features

* Supports receiving any DNS query for a given domain.
* Always returns with `NXDOMAIN` to prevent DNS caching.

## Examples

```ruby
Ronin::Exfil::DNS.listen('example.com', host: '127.0.0.1', port: 5553) do |query_type,query_value|
  puts "Received query for #{query_type} #{query_value}"
end
```

Then try running `host -p 5553 s3cr3t.example.com 127.0.0.1` to test the server.

```
Received query for A s3cr3t.example.com
```

**Note:** if you wish to run the server on `0.0.0.0` and port `53`, the ruby
script must be ran as `root`.

## Requirements

* [Ruby] >= 3.0.0
* [async-dns] ~> 1.0

## Install

```shell
$ gem install ronin-exfil-dns
```

### Gemfile

```ruby
gem 'ronin-exfil-dns', '~> 0.1'
```

### gemspec

```ruby
gem.add_dependency 'ronin-exfil-dns', '~> 0.1'
```

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin-exfil-dns/fork)
2. Clone It!
3. `cd ronin-exfil-dns/`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code It!
7. `bundle exec rake spec`
8. `git push origin my_feature`

## License

Copyright (c) 2023 Hal Brodigan (postmodern.mod3@gmail.com)

ronin-exfil-dns is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ronin-exfil-dns is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with ronin-exfil-dns.  If not, see <https://www.gnu.org/licenses/>.

[Ruby]: https://www.ruby-lang.org
[async-dns]: https://github.com/socketry/async-dns#readme
