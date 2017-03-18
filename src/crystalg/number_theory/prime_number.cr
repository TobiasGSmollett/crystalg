
module Crystalg::NumberTheory
  def get_divisor(n : Int32): Array(Int32)
    result = Array(Int32).new
    i = 1
    while i * i <= n
      if(n % i == 0)
        result << i
        result << n / i if i != n / i
      end
      i = i.succ
    end
    result
  end

  def prime_factorize(n : Int32): Hash(Int32, Int32)
    result = Hash(Int32, Int32).new
    i = 2
    while i * i <= n
      count = 0
      while n % i == 0
        count += 1
        n /= i
      end
      result[i] = count if count > 0
      i = i.succ
    end
    result[n] = 1 if n != 1
    result
  end

  def sieve_of_eratosthenes(n : Int32)
    result = Array(Bool).new(n + 1, true)
    result[0] = result[1] = false
    i = 2
    while i * i <= n
      if(result[i] == true)
        j = i * i
        while j <= n
          result[j] = false
          j = j + i
        end
      end
      i = i.succ
    end
    result
  end
end