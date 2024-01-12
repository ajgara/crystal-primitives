require "big"
require "./crystal-primitives"

include CrystalPrimitives

module EllipticCurves
    VERSION = "0.1.0"
    
    class EllipticCurvePoint
        @@a : FieldElement = FieldElement.new BigInt.new 0
        @@b : FieldElement = FieldElement.new BigInt.new 7

        @x : FieldElement
        @y : FieldElement

        def initialize(x : FieldElement, y : FieldElement)
            @x = x
            @y = y
            two = BigInt.new(2)
            three = BigInt.new(3)
            if y**two != x**three +@@a*x + @@b
                raise ArgumentError.new("the point is not on the curve")
            end
        end

        def self.initialize_from_x(x : FieldElement)
            three = BigInt.new(3)
            y = x**three + @@a*x + @@b
            y = y.squareRoot() 
            point = self.new(x, y)
            puts point.point()
            return point
        end

        def point
            return @x, @y
        end

        def curve
            return @@a, @@b
        end


        def ==(other : EllipticCurvePoint)

            x, y = self.point
            x0, y0 = other.point 
            same_point = (x==x0) && (y == y0)

            same_curve = self.curve == other.curve
            return same_point && same_curve
        end

    end
end
require "spec"

include EllipticCurves


describe EllipticCurves do

    describe "EllipticCurvePoint" do
        it "can initialize from first coordinate x" do
            x = FieldElement.new(BigInt.new 1)
            p = EllipticCurvePoint.initialize_from_x(x)
            p.should eq(EllipticCurvePoint.new(FieldElement.new(BigInt.new 1), FieldElement.new(BigInt.new 1024)))
        end

        # it "equality operator works" do
        #     x = FieldElement.new(1)

        #     y = BigInt.new("")


        #     p = EllipticCurvePoint.initialize_from_x(x)
        #     q = EllipticCurvePoint.new(x, y)
        #     p.should eq q
        # end
    end

end
