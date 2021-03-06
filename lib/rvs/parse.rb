require 'strscan'
require 'bigdecimal'
require 'yajl'

module RVS
class Parser
  def initialize(str)
    @scan = StringScanner.new(str)
  end

  def run
    parse_item
  end

  def parse_item
    next_char = @scan.getch
    if next_char == '['
      parse_array
    elsif next_char == '{'
      parse_hash
    elsif next_char == '"'
      if @scan.peek(1) == '"'
        get_chars(1)
        ''
      else
        strval = '"' + @scan.scan(/.*?[^\\]+?\"/)
        Yajl::Parser.new.parse(strval)
      end
    elsif next_char == ':'
      @scan.scan(/[a-zA-Z_]+\w*/).to_sym
    elsif next_char == 'd'
      strval = @scan.scan(/[0-9-]+/)
      if @scan.peek(1) == ' '
        strval += get_chars(9)
        DateTime.strptime(strval, '%Y-%m-%d %H:%M:%S')
      else
        Date.strptime(strval, '%Y-%m-%d')
      end
    elsif next_char == 'f'
      if @scan.peek(1) == 'a'
        get_chars(4)
        false
      else
        @scan.scan(/-?[0-9\.]+/).to_f
      end
    elsif next_char == 't'
      if @scan.peek(1) == 'r'
        get_chars(3)
        true
      else
        Time.strptime(get_chars(19), '%Y-%m-%d %H:%M:%S')
      end
    elsif next_char == 'c'
      BigDecimal(@scan.scan(/-?[0-9\.]+/))
    elsif next_char == 'n'
      get_chars(2)
      nil
    elsif next_char =~ /[0-9-]/
      @scan.pos = @scan.pos - 1
      @scan.scan(/-?\d+/).to_i
    else
      raise "unexpected type identifier *#{next_char}*; string remainder is #{@scan.rest}"
    end
  end

  def parse_array
    retval = []
    while !@scan.eos?
      next_char = @scan.peek(1)
      if next_char == ']'
        # throw away the closing ]
        @scan.getch
        break
      end
      # throw away the ,
      @scan.getch if next_char == ','
      retval.push(parse_item)
    end
    retval
  end

  def parse_hash
    retval = {}
    curr_key = nil
    while !@scan.eos?
      next_char = @scan.peek(1)
      if next_char == '}'
        # throw away the closing }
        @scan.getch
        break
      end
      # throw away the following delimiter chars
      @scan.getch if next_char == ','
      get_chars(2) if next_char == '='

      next_value = parse_item
      if curr_key
        retval[curr_key] = next_value
        curr_key = nil
      else
        curr_key = next_value
      end
    end
    retval
  end

  def get_chars(count)
    retval = @scan.peek(count)
    @scan.pos = @scan.pos + count
    retval
  end
end

def self.parse(str)
  Parser.new(str).run
end
end
