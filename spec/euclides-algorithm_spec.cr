require "./spec_helper"
require "../src/euclides-algorithm.cr"

#include EuclidesAlgorithm



describe "euclidesAlgorithm" do
    a = BigInt.new 12
    b = BigInt.new 18
    r, s = euclidesAlgorithm(a,b)
    (r*a + s*b).should eq(BigInt.new 6)
end

