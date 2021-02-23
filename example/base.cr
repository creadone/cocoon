require "json"
require "../src/cocoon"
require "http/client"

alias Response = HTTP::Client::Response
cocoon = Cocoon::Wrapper(Response).new

channel = cocoon.wrap do
  headers = HTTP::Headers{ "Accept" => "application/vnd.github.v3+json" }
  HTTP::Client.get "https://api.github.com/networks/crystal-lang/crystal/events", headers: headers
end

if resp = channel.receive
  if resp.is_a?(Response) && resp.success?
    pp JSON.parse(resp.body)
  elsif resp.is_a?(Exception)
    # log it and raise resp
  end
end