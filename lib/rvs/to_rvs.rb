require 'bigdecimal'
require 'date'
require 'time'

class String
  def to_rvs
    "s#{size}:#{self}"
  end
end

module WholeNumberToRvs
  def to_rvs
    "w#{self}"
  end
end

class Fixnum
  include WholeNumberToRvs
end

class Bignum
  include WholeNumberToRvs
end

class FalseClass
  def to_rvs
    'false'
  end
end

class TrueClass
  def to_rvs
    'true'
  end
end

class BigDecimal
  def to_rvs
    "c#{to_s('F')}"
  end
end

class Date
  def to_rvs
    "d#{strftime('%Y%m%d')}"
  end
end

class DateTime
  def to_rvs
    "e#{strftime('%Y%m%d%H%M%S')}"
  end
end

class Time
  def to_rvs
    "t#{strftime('%Y%m%d%H%M%S')}"
  end
end

class Array
  def to_rvs
    inner = collect {|elem| elem.to_rvs }.join(',')
    "[#{inner}]"
  end
end

class Hash
  def to_rvs
    ary = []
    each_pair do |key, value|
      ary.push("#{key.to_rvs}>#{value.to_rvs}")
    end
    "{#{ary.join(',')}}"
  end
end

class NilClass
  def to_rvs
    'nil'
  end
end
