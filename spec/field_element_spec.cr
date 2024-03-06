require "./spec_helper"

include FieldElements

describe FieldElements do
  describe "#==" do
    
    it "131072 and 1 are the same element in a Finite Field of order 131071" do
      x = FieldElement(GF_131071).new BigInt.new 131072
      y = FieldElement(GF_131071).new BigInt.new 1
      x.should eq(y)
    end

    it "three modulo 131071 is equal to 131074 modulo 131071" do
      x = FieldElement(GF_131071).new BigInt.new 3
      y = FieldElement(GF_131071).new BigInt.new 131074
      x.should eq(y)
    end
  end

  describe "#+" do
    it "works" do
      x = FieldElement(GF_131071).new BigInt.new 2
      y = FieldElement(GF_131071).new BigInt.new 126
      z = x + y
      (x + y).should eq(FieldElement(GF_131071).new BigInt.new 128)
    end
  end

  describe "·*" do
    it "works" do
      x = FieldElement(GF_131071).new BigInt.new 257
      y = FieldElement(GF_131071).new BigInt.new 510
      z = x * y
      z.should eq(FieldElement(GF_131071).new BigInt.new 131070)
    end
  end

  describe "#**" do
    it "can do a small exponentation" do 
      x = FieldElement(GF_131071).new BigInt.new 2
      exponent : BigInt = BigInt.new 2
      (x**exponent).should eq(FieldElement(GF_131071).new BigInt.new 4)
    end

    it "can exponentiate to larger numbers" do
      x = FieldElement(GF_131071).new BigInt.new 2
      exponent : BigInt = BigInt.new 17
      result = x**exponent
      (result).should eq(FieldElement(GF_131071).new BigInt.new 1)
    end

  describe "#squareroot" do
    it "can do the squareroot of 2" do
      x = FieldElement(GF_131071).new BigInt.new 2
      sqrtX = x.square_root()
      two = BigInt.new(2)
      (sqrtX**two).should eq(x)
    end

    it "can do the squareroot of 100" do
      x = FieldElement(GF_131071).new BigInt.new 100
      sqrtX = x.square_root()
      two = BigInt.new(2)
      (sqrtX**two).should eq(x)
    end

    it "raises error if field element does not have squareroot" do
      x = FieldElement(GF_131071).new BigInt.new 3
      expect_raises(ArgumentError) do
        sqrtX = x.square_root()
      end
    end
  end

  it "can do the inverse" do
    x = FieldElement(GF_131071).new BigInt.new 2
    inverse = x.inverse_of()
    (x*inverse).should eq(FieldElement(GF_131071).new BigInt.new 1)
  end

  end
end

describe "euclidesAlgorithm" do
  a = BigInt.new 12
  b = BigInt.new 18
  r, s = euclides_algorithm(a,b)
  (r*a + s*b).should eq(BigInt.new 6)
end
