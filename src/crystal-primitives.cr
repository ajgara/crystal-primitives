require "big"
require "logger"

log = Logger.new(STDOUT)
log.level = Logger::ERROR

module CrystalPrimitives
  VERSION = "0.1.0"

  abstract class FieldElement
      def initialize(number : BigInt)
          @number = number % self.prime_order
      end
  
      def number
          @number
      end
  
      def +(other : FieldElement)
        Log.error("before describe works")
        self.class.new ((self.number + other.number) % self.prime_order)
      end

      def ==(other : FieldElement)
        self.number == other.number
      end
  
      def to_s(io : IO) : Nil
          io.print self.number
      end
  
      abstract def prime_order() : BigInt
  end
  
  class FE7 < FieldElement
      def prime_order() : BigInt
          BigInt.new 7
      end
  end
end
