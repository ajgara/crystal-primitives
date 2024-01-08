require "big"
#require "logger"

#log = Logger.new(STDOUT)
#log.level = Logger::ERROR

module CrystalPrimitives
  VERSION = "0.1.0"

  class FieldElement
    @@prime : BigInt = BigInt.new 131071
    @number : BigInt

      def initialize(number : BigInt)
          @number = number % @@prime
      end
  
      def number
          @number
      end
  
      def +(other : FieldElement)
        #Log.error("before describe works")
        self.class.new ((self.number + other.number) % @@prime)
      end

      def *(other : FieldElement)
        self.class.new ((self.number * other.number) % @@prime)
      end

      def inverseOf()
        s, t = euclidesAlgorithm(self.number(), @@prime)
        inverse = s%@@prime
        return self.class.new inverse
      end

      def ==(other : FieldElement)
        self.number == other.number
      end

      def **(exponent : BigInt)
        self.class.new (self.number ** exponent) % @@prime
      end
  
      def to_s(io : IO) : Nil
          io.print self.number
      end
  
  end

  class PublicValues
    @@p : BigInt = BigInt.new 131071
    @@q : BigInt = BigInt.new 257
    @@z : BigInt = BigInt.new 510 
    @@h : BigInt = BigInt.new 80843 #chosen at random
    @@g : BigInt = ((@@h)**z)%@@p


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

    def initialize()
      @privateKey = Random.rand(PublicValues.q() -1)
      @publicKey = (FieldElement.new(PublicValues.g())) ** @privateKey
    end

    def publicKey
      @publicKey
    end

    # def sign(message, )
    #   k = Random.rand(PublicValues.q() -1)

    #   r = FieldElement.new(PublicValues.g()) ** k

    #   s = 
  
  end



  def sign() #messageHash : BigInt, privateKey: BigInt
    #puts PublicValues.p
    #puts PublicValues.q
    puts "hello"
  end

end  