require "big"
require "./elliptic-curves.cr"

include EllipticCurves
#require "logger"

#log = Logger.new(STDOUT)
#log.level = Logger::ERROR


puts "hello world"

# i = 1
# is_true = true
# while i < 101
#   begin
#     # Your code that might raise an exception
#     # For example, let's simulate a division by zero
#     value = FieldElement.new(BigInt.new(i))
#     p = EllipticCurvePoint.initialize_from_x(value)

#     puts p.point[0].number
#     # Your code logic here

#   rescue
#     # Handle the exception (or you can leave this block empty to ignore)
#     puts "Exception occurred, but continuing..."
#   end
#   i = i+1
# end


x1 = FieldElement.new(BigInt.new 1)
x2 = FieldElement.new(BigInt.new 3)

p1 = EllipticCurvePoint.initialize_from_x(x1)
p2 = EllipticCurvePoint.initialize_from_x(x2)

y1 = FieldElement.new(BigInt.new 1024)
y2 = FieldElement.new(BigInt.new 107193)



p3 = p1 + p2

puts p3.point # 101475, 58381

s = (y2 - y1)*((x2 - x1).inverseOf())
puts "s"
puts s #118620
x3 = s*s - x1 - x2
puts x3
y3 = s*(x1 - x3) - y1
puts y3
puts EllipticCurvePoint.new(x3, y3).point

# puts EllipticCurvePoint

x1 = FieldElement.new(BigInt.new 1)
p1 = EllipticCurvePoint.initialize_from_x(x1)
p2 = EllipticCurvePoint.initialize_from_x(x1)

p3 = p1 + p2
puts "sum same point"
puts y1
puts (y1+y1).inverseOf
s = ((x1*x1)+(x1*x1)+(x1*x1) )*((y1+y1).inverseOf())
puts "s", s
x3 = s*s - x1 - x1
y3 = s*(x1 - x3) - y1
puts EllipticCurvePoint.new(x3, y3).point
puts p3

