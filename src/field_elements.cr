require "big"


module FieldElements
  VERSION = "0.1.0"

  abstract class FieldConfig
    abstract def modulus()
  end

  class FieldElement(T) 
    @number : BigInt

    def initialize(number : BigInt)
      @number = number % T.new.modulus()
    end

    def number
      @number
    end

    def +(other : FieldElement)
      FieldElement(T).new((self.number + other.number) % T.new.modulus())
    end

    def -(other : FieldElement)
      FieldElement(T).new((self.number - other.number) % T.new.modulus())
    end

    def *(other : FieldElement)
      FieldElement(T).new((self.number * other.number) % T.new.modulus())
    end

    def ==(other : FieldElement)
      self.number == other.number
    end

    def **(exponent : BigInt)
      FieldElement(T).new (self.number ** exponent) % T.new.modulus()
    end

    def inverseOf
      s, t = euclidesAlgorithm(self.number, T.new.modulus())
      inverse = s % T.new.modulus()
      return FieldElement(T).new inverse
    end

    def squareRoot
      exponent = T.new.modulus() + BigInt.new(1)
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

def euclidesAlgorithm(a : BigInt, b : BigInt)
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
  inverse, t = euclidesAlgorithm(number, mod)
  inverse = inverse % mod
  return inverse
end
