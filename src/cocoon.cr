module Cocoon
  VERSION = `shards version`

  class Wrapper(T)
    def initialize(
      @result = Channel(T | Exception | Nil).new,
      @output = Channel(T | Exception | Nil).new
    )
    end

    def wrap(&block : -> T) forall T
      spawn(name: "executor") do
        data = block.call
        @result.send data
      rescue ex
        @result.send ex
      end

      Fiber.yield

      spawn(name: "receiver") do
        select
        when data = @result.receive
          @output.send data
        else
          @output.send nil
        end
      end
      @output.receive
    end
  end
end
