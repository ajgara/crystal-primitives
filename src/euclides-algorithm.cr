require "big"


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

a = BigInt.new 28218902
b = BigInt.new 21890213980

s, t = euclidesAlgorithm(a, b)
