# localtunnel [![Gem version](http://img.shields.io/gem/v/localtunnel.svg?style=flat-square)](http://rubygems.org/gems/localtunnel)

Ruby gem wrapping the [localtunnel](https://localtunnel.me/) npm package.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'localtunnel'
```

And then execute:

```bash
$ bundle install
```

Lastly, install the localtunnel npm package and ensure that it is available in your `PATH`:

```bash
$ npm install -g localtunnel
```

## Usage

A basic example:

```ruby
require 'localtunnel'

Localtunnel::Client.start(port: 3000)

Localtunnel::Client.running? # => true

Localtunnel::Client.url # => https://pnevcucqgb.localtunnel.me

Localtunnel::Client.stop
```

Extra options can also be specified:

```ruby
Localtunnel::Client.start(
  port: 3000,
  subdomain: 'hello',
  remote_host: 'http://my-domain-1.com',
  local_host: 'http://my-domain-2.com'
)
```

## Related

It is also worth checking out [ngrok-tunnel](https://github.com/bogdanovich/ngrok-tunnel), a gem that is similar in function to this one and served as its inspiration.
