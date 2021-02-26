module Cocoon
  VERSION = `shards version`

  class Wrapper(T)
    def initialize(
      @result = Channel(T | Exception).new,
      @output = Channel(T | Exception).new
    )
    end

    def wrap(&block : -> T) forall T
      spawn(name: "executor") do
        @result.send block.call
        rescue ex
          @result.send ex
      end

      Fiber.yield

      spawn(name: "receiver") do
        @output.send @result.receive
      end
      @output
    end
  end
end
