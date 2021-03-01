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
        if data = block.call
          @result.send data
        end
        rescue ex
          @result.send ex
      end

      Fiber.yield

      spawn(name: "receiver") do
        if data = @result.receive
          @output.send data
        end
      end
      @output
    end
  end
end
