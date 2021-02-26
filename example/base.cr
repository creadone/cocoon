require "log"
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