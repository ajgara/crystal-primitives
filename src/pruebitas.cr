require "big"
#require "./elliptic-curves.cr"

#include EllipticCurves
#require "logger"

#log = Logger.new(STDOUT)
#log.level = Logger::ERROR


puts "hello world"

seeded_random = Random.new(42)
puts seeded_random.rand(100)