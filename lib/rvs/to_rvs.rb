require 'bigdecimal'
require 'date'
require 'time'

class String
  def to_rvs
    raise "non-ascii strings aren't currently supported" unless ascii_only?
    no_specials = gsub(/\n/, '\n').gsub(/\r/, '\r').gsub(/\t/, '\t')
    if index('"') || index('\\')
      "s#{size}:#{no_specials}"
    else
      %Q{"#{no_specials}"}
    end
  end
end

class Fixnum
  alias :to_rvs :to_s
end

class Bignum
  alias :to_rvs :to_s
end

class FalseClass
  alias :to_rvs :to_s
end

class TrueClass
  alias :to_rvs :to_s
end

class BigDecimal
  def to_rvs
    "c#{to_s('F')}"
  end
end

class Date
  def to_rvs
    "d#{strftime('%Y-%m-%d')}"
  end
end

class DateTime
  def to_rvs
    "d#{strftime('%Y-%m-%d %H:%M:%S')}"
  end
end

class Time
  def to_rvs
    "t#{strftime('%Y-%m-%d %H:%M:%S')}"
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
      ary.push("#{key.to_rvs}=>#{value.to_rvs}")
    end
    "{#{ary.join(',')}}"
  end
end

class NilClass
  def to_rvs
    'nil'
  end
end

class Symbol
  def to_rvs
    ":#{to_s}"
  end
end

class Float
  def to_rvs
    "f#{to_s}"
  end
end
