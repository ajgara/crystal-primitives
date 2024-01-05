require "./spec_helper"

include CrystalPrimitives

describe CrystalPrimitives do
  describe "#==" do
    it "three modulo 7 is equal to 10 modulo 7" do
      x = FE7.new BigInt.new 3
      y = FE7.new BigInt.new 10
      x.should eq(y)
    end
  end

  describe "#+" do
    it "works" do
      x = FE7.new BigInt.new 3
      y = FE7.new BigInt.new 250
      z = x + y
      #(x + y).should eq(FE7.new BigInt.new 1)
    end
  end
end
