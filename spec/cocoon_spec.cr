require "./spec_helper"

describe Cocoon do
  describe "Wrapper" do
    cocoon = Cocoon::Wrapper(Int32).new

    it "should return sum of integers" do
      if result = cocoon.wrap { 1 + 3 }
        result.should eq(4)
      end
    end
  end
end
