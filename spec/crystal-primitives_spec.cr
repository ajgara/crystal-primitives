require "./spec_helper"

include CrystalPrimitives

describe CrystalPrimitives do




  describe "#==" do
    
    it "131072 and 1 are the same element in a Finite Field of order 131071" do
      x = FieldElement.new BigInt.new 131072
      y = FieldElement.new BigInt.new 1
      x.should eq(y)
    end

    it "three modulo 131071 is equal to 131074 modulo 131071" do
      x = FieldElement.new BigInt.new 3
      y = FieldElement.new BigInt.new 131074
      x.should eq(y)
    end
  end

  describe "#+" do
    it "works" do
      x = FieldElement.new BigInt.new 2
      y = FieldElement.new BigInt.new 126
      z = x + y
      (x + y).should eq(FieldElement.new BigInt.new 128)
    end
  end

  describe "#**" do
    it "can do a small exponentation" do 
      x = FieldElement.new BigInt.new 2
      exponent : BigInt = BigInt.new 2
      (x**exponent).should eq(FieldElement.new BigInt.new 4)
    end

    it "can exponentiate to larger numbers" do
      x = FieldElement.new BigInt.new 2
      exponent : BigInt = BigInt.new 17
      result = x**exponent
      (result).should eq(FieldElement.new BigInt.new 1)
    end

    it "can do the inverse" do
      x = FieldElement.new BigInt.new 2
      inverse = x.inverseOf()
      (x*inverse).should eq(FieldElement.new BigInt.new 1)
    end

  end


  describe "#PublicValues" do
    
    it "q is well defined" do
      ((PublicValues.p() -1)%PublicValues.q()).should eq(0)
    end

    it "z is well defined" do
      ((PublicValues.p() - 1)/PublicValues.q).should eq(PublicValues.z)
    end

    it "generator g is well defined" do
      (PublicValues.g).should be > 1
    end

  end


  describe "#Signer" do

    it "is well initialized" do
      signer = Signer.new
    end


  end



end
