require "big"


module FieldElements
  VERSION = "0.1.0"

  class GF_131071
    @[AlwaysInline]
    def self.modulus
      BigInt.new 131071
    end
  end

  class FieldElement(T) 
    @number : BigInt

    def initialize(number : BigInt)
      @number = number % T.modulus
    end

    def number
      @number
    end

    def +(other : FieldElement)
      FieldElement(T).new((self.number + other.number) % T.modulus)
    end

    def -(other : FieldElement)
      FieldElement(T).new((self.number - other.number) % T.modulus)
    end

    def *(other : FieldElement)
      FieldElement(T).new((self.number * other.number) % T.modulus)
    end

    def ==(other : FieldElement)
      self.number == other.number
    end

    def **(exponent : BigInt)
      FieldElement(T).new (self.number ** exponent) % T.modulus
    end

    def inverse_of
      s, t = euclides_algorithm(self.number, T.modulus)
      inverse = s % T.modulus
      return FieldElement(T).new inverse
    end

    def square_root
      exponent = T.modulus + BigInt.new(1)
      exponent = exponent // BigInt.new(4)

      result = self ** exponent

      if result**(BigInt.new(2)) != self
        raise ArgumentError.new("element does not have a square root")
      end

      return result
    end

    def to_s(io : IO) : Nil
      io.print self.number
    end
  end
end

def euclides_algorithm(a : BigInt, b : BigInt)
  r0 = a
  r1 = b

  s0 = 1
  s1 = 0
  t0 = 0
  t1 = 1

  while r1 != 0
      
      temp_r0 = r0
      r0 = r1

      q = temp_r0//r1
      r1 = temp_r0 % r1  

      temp_s0 = s0
      s0 = s1
      s1 = temp_s0 - q * s1

      temp_t0 = t0
      t0 = t1
      t1 = temp_t0 - q * t1

  end
  return s0, t0
end

def inverse_mod_q(number : BigInt, mod : BigInt)
  inverse, t = euclides_algorithm(number, mod)
  inverse = inverse % mod
  return inverse
end
