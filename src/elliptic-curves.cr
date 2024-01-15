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

        @is_infinity : Bool = false

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
            y  = y.squareRoot() 
            point = self.new(x, y)
            return point
        end

        def self.initialize_infinity_point()
            placeholder_field_element_x = FieldElement.new(BigInt.new 1)
            placeholder_field_element_y = FieldElement.new(BigInt.new 1024)
            p = self.new(placeholder_field_element_x, placeholder_field_element_y)
            p.set_point_as_infinity()
            return p
        end

        def set_point_as_infinity()
            @is_infinity = true
        end

        def is_infinity()
            return @is_infinity
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

        def +(other : EllipticCurvePoint)

            if self.is_infinity()
                return other
            end
            if other.is_infinity()
                return self
            end

            x1, y1 = self.point
            x2, y2 = other.point

            if self == other && y1 == FieldElement.new(BigInt.new 0)
                return EllipticCurvePoint.initialize_infinity_point()
            end

            if self == other
                s = ((x1*x1)+(x1*x1)+(x1*x1) + @@a)*((y1+y1).inverseOf())
                x3 = s*s - x1 - x1
                y3 = s*(x1 - x3) - y1
                return EllipticCurvePoint.new(x3, y3)
            end

            if x1 == x2
                return EllipticCurvePoint.initialize_infinity_point()
            end

            s = (y2 - y1)*((x2 - x1).inverseOf())
            x3 = s*s - x1 - x2
            y3 = s*(x1 - x3) - y1
            return EllipticCurvePoint.new(x3, y3)
        end

    end
end
require "spec"

include EllipticCurves


describe EllipticCurves do

    describe "EllipticCurvePoint" do
        it "can initialize from first coordinate x and compare to start initialization" do
            x = FieldElement.new(BigInt.new 1)
            p = EllipticCurvePoint.initialize_from_x(x)
            other_point = EllipticCurvePoint.new(FieldElement.new(BigInt.new 1), FieldElement.new(BigInt.new 1024))
            p.should eq(other_point)
        end

        it "raises error if there is no point on the curve with x" do
            x = FieldElement.new(BigInt.new 2)
            expect_raises(ArgumentError) do
                p = EllipticCurvePoint.initialize_from_x(x)
            end
        end

        it "can initialize infinity point" do
            p = EllipticCurvePoint.initialize_infinity_point()
            p.is_infinity().should be_truthy
        end

    end

    describe "#+" do

        it "can sum when first summand is infinity" do
            s1 = EllipticCurvePoint.initialize_infinity_point()
            s2 = EllipticCurvePoint.initialize_from_x(FieldElement.new(BigInt.new 1))

            p = s1 + s2
            p.should eq(s2)
        end

        it "can sum additive inverses and return infinity" do
            x = FieldElement.new(BigInt.new 1)
            y1 = FieldElement.new(BigInt.new 1024)
            y2 = FieldElement.new(BigInt.new 130047)
            p1 = EllipticCurvePoint.new(x, y1)
            p2 = EllipticCurvePoint.new(x, y2)

            result = (p1 + p2).as(EllipticCurvePoint)
            result.is_infinity().should be_truthy
        end

        it "can sum generic points" do
            x1 = FieldElement.new(BigInt.new 1)
            x2 = FieldElement.new(BigInt.new 3)
            p1 = EllipticCurvePoint.initialize_from_x(x1)
            p2 = EllipticCurvePoint.initialize_from_x(x2)

            p3 = p1 + p2

            expected_x3 = FieldElement.new(BigInt.new 101475)
            expected_y3 = FieldElement.new(BigInt.new 58381)
            p3.should eq(EllipticCurvePoint.new(expected_x3, expected_y3))

        end

        it "can sum the same point" do
            x1 = FieldElement.new(BigInt.new 1)
            p1 = EllipticCurvePoint.initialize_from_x(x1)
            p2 = EllipticCurvePoint.initialize_from_x(x1)

            p3 = p1 + p2

            expected_x3 = FieldElement.new(BigInt.new 36862)
            expected_y3 = FieldElement.new(BigInt.new 130569)
            p3.should eq(EllipticCurvePoint.new(expected_x3, expected_y3))   
        end

    end

end
