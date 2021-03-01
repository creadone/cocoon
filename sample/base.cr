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