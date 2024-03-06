require "./spec_helper"

include DSA

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

    it "it initializes and signs a message without errors" do
    signer = Signer.new
    signer.sign(BigInt.new 100)
    end

end

describe "#verify" do

    it "should be false if signature is too large" do
    signer = Signer.new
    message = BigInt.new 100
    r, s = signer.sign(message)

    result = verify_signature(signer, BigInt.new(300), BigInt.new(300), message)
    result.should be_falsey
    end

    it "should verify well signed message" do
    signer = Signer.new
    message = BigInt.new 100
    r, s = signer.sign(message)

    result = verify_signature(signer, r.as(BigInt), s.as(BigInt), message)
    result.should be_truthy
    end
end
