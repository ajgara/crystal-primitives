require "big"
require "./crystal-primitives"
require "./elliptic-curves"

include CrystalPrimitives
include EllipticCurves


module ECDSA
    VERSION = "0.1.0"

    class ECDSAPublicValues

        @@p : BigInt = BigInt.new 131071
        @@G : EllipticCurvePoint = EllipticCurvePoint.new(FieldElement.new(BigInt.new(7558)), FieldElement.new(BigInt.new(115065)))
        @@generator_point_order = BigInt.new 43573

        def self.generator 
            @@G
        end

        def self.p
            @@p
        end

        def self.order_of_generator
            @@generator_point_order
        end

    end


    class ECDSASigner

        @privateKey : FieldElement
        @publicKey : EllipticCurvePoint
        @rng : Random
    
        def initialize(rng)
          @rng = rng

          private_key_as_int = @rng.rand(ECDSAPublicValues.order_of_generator())
          @privateKey = FieldElement.new(private_key_as_int.as(BigInt))
          
          @publicKey = ECDSAPublicValues.generator().scalar_mul(@privateKey.number())
        end
    
        def publicKey
          @publicKey
        end
    
        def sign(messageHash : FieldElement)
            
            k = (@rng.rand(ECDSAPublicValues.p() -1).as(BigInt)) % ECDSAPublicValues.order_of_generator()
            z = messageHash.number % ECDSAPublicValues.order_of_generator()

            _R = ECDSAPublicValues.generator().scalar_mul(k)
            r, _ = _R.point

            r = r.number() % ECDSAPublicValues.order_of_generator()
            x = @privateKey.number() % ECDSAPublicValues.order_of_generator()

            s = (z + r*x)*(inverse_mod_q(k, ECDSAPublicValues.order_of_generator())) 
            s = s % ECDSAPublicValues.order_of_generator()

            return r, s
          
        end
    
    end


    def eCDSA_verify_signature(signer : ECDSASigner, messageHash : FieldElement, r : BigInt, s : BigInt)
        
        g = ECDSAPublicValues.generator()
        
        inverse_of_s = inverse_mod_q(s, ECDSAPublicValues.order_of_generator())

        u = (messageHash.number() * inverse_of_s)
        v = (r * inverse_of_s) % ECDSAPublicValues.order_of_generator()
        


        uG = g.scalar_mul(u)
        vP = signer.publicKey().scalar_mul(v)

        candidate = uG + vP

        x, _ = candidate.point()
        x = x.number() % ECDSAPublicValues.order_of_generator()
        return x == r
    end

end


# Tests

require "spec"
include ECDSA



describe ECDSASigner do

    it "can initialize without errors" do
        rng = Random.new(42)
        signer = ECDSASigner.new(rng)
    end

    it "can sign a message" do
        rng = Random.new(42)
        signer = ECDSASigner.new(rng)
        message_hash = FieldElement.new(BigInt.new(3))

        r, s = signer.sign(message_hash)

        r.should eq(26152)
        s.should eq(17952)
        
    end

    it "can sign and verify a message" do
        rng = Random.new(42)
        signer = ECDSASigner.new(rng)

        message_hash = FieldElement.new(BigInt.new(1))
        r, s = signer.sign(message_hash)
        is_valid = eCDSA_verify_signature(signer, message_hash, r, s)

        is_valid.should be_truthy
    end

end


describe ECDSAPublicValues do

    it "generator G is well defined" do
        x = FieldElement.new BigInt.new 7558
        y = FieldElement.new BigInt.new 115065

        g : EllipticCurvePoint = EllipticCurvePoint.new(x, y)

        ECDSAPublicValues.generator().should eq(g)
        #g.scalar_mul(BigInt.new 43573).should eq(EllipticCurvePoint.initialize_infinity_point())
        
    end

    it "generator G has correct order" do
        g : EllipticCurvePoint = ECDSAPublicValues.generator()

        generator_point_order = BigInt.new 43573

        g.scalar_mul(generator_point_order).should eq(EllipticCurvePoint.initialize_infinity_point())
        
    end
    
end

