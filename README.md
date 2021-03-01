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
require "cocoon"
require "http/client"

alias Response = HTTP::Client::Response
cocoon = Cocoon::Wrapper(Response).new

loop do
  result = cocoon.wrap do
    if Random.rand > 0.5
      HTTP::Client.get("https://github.com")
    else
      raise "Connection is lost"
    end
  end

  # something in the &block raised Exception
  if result.is_a?(Exception)
    puts result.message
  end

  # &block is done
  if result.is_a?(Response)
    puts "X-GitHub-Request-Id: #{result.headers["X-GitHub-Request-Id"]}"
  end

  # &block has no result or task is not ended yet
  if result.is_a?(Nil)
    puts "Nothing..."
  end

  sleep 1
end

# => Nothing...
# => X-GitHub-Request-Id: EF51:10C35:3A33E0D:3BCCF8A:603C72E7
# => Connection is lost
# => X-GitHub-Request-Id: EF52:0AF5:44114C4:45B5044:603C72E9
# => X-GitHub-Request-Id: EF53:E298:B55ADC:B9B0DF:603C72EA
# => Connection is lost
# => Connection is lost
```

## Contributing

1. Fork it (<https://github.com/creadone/cocoon/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [creadone](https://github.com/creadone) - creator and maintainer
