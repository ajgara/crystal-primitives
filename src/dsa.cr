require "big"
require "./field_elements"

module DSA
  class PublicValues
    @@p : BigInt = BigInt.new 131071
    @@q : BigInt = BigInt.new 257
    @@z : BigInt = BigInt.new 510
    @@h : BigInt = BigInt.new 80843 # chosen at random
    @@g : BigInt = ((@@h)**z) % @@p

    def self.p
      @@p
    end

    def self.q
      @@q
    end

    def self.z
      @@z
    end

    def self.g
      @@g
    end
  end

  class Signer
    @privateKey : BigInt
    @publicKey : FieldElement

    def initialize
      @privateKey = Random.rand(PublicValues.q - 1)
      @publicKey = (FieldElement.new(PublicValues.g)) ** @privateKey
    end

    def publicKey
      @publicKey
    end

    def sign(messageHash : BigInt)
      r_as_field_element = FieldElement.new BigInt.new 0

      while r_as_field_element == FieldElement.new BigInt.new 0
        k = Random.rand((PublicValues.q - 1).as(Int))
        r_as_field_element = FieldElement.new(PublicValues.g) ** k
        r = r_as_field_element.number % PublicValues.q
      end

      # inverse of k
      inverse_k, t = euclidesAlgorithm(k.as(BigInt), PublicValues.q)
      inverse_k = inverse_k % PublicValues.q

      s = inverse_k * (messageHash + @privateKey*r.as(BigInt))
      s = s.as(BigInt) % PublicValues.q

      r = r.as(BigInt) % PublicValues.q

      return r, s
    end
  end

  def verify_signature(signer : Signer, r : BigInt, s : BigInt, messageHash : BigInt)
    q = PublicValues.q

    if r >= q
      puts r
      return false
    end
    if s >= q
      puts s
      return false
    end

    w = inverse_mod_q(s, q)

    u1 = (messageHash * w) % q
    u2 = (r*w) % q

    # computation of v
    g = FieldElement.new PublicValues.g
    factor1 = (g**u1)
    factor2 = (signer.publicKey**u2)
    v = ((factor1 * factor2).number) % q

    return v == r
  end
end
