# Cocoon

Wrapper for IO such as third-party API calls to prevent sudden blow up the main program.

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  cocoon:
    github: creadone/cocoon
```

2. Run `shards install`

## Usage

```crystal
require "json"
require "cocoon"
require "http/client"

alias Response = HTTP::Client::Response
cocoon = Cocoon::Wrapper(Response).new

channel = cocoon.wrap do
  headers = HTTP::Headers{ "Accept" => "application/vnd.github.v3+json" }
  HTTP::Client.get "https://api.github.com/networks/crystal-lang/crystal/events", headers: headers
end

if resp = channel.receive
  if resp.is_a?(Response)
    if resp.success?
      pp Array(Hash(String, JSON::Any)).from_json(resp.body)
    else
      Log.warn{ HTTP::Status.new(resp.status_code).description }
    end
  elsif resp.is_a?(Exception)
    Log.warn exception: resp, &.emit("Hi dear! I missed you.")
  end
end
```

## Contributing

1. Fork it (<https://github.com/creadone/cocoon/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [creadone](https://github.com/creadone) - creator and maintainer
