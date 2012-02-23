require 'strscan'
require 'bigdecimal'

module RVS
class Parser
  def initialize(str)
    @scan = StringScanner.new(str)
  end

  def run
    parse_item
  end

  def parse_item
    next_char = @scan.peek(1)
    if next_char == '['
      parse_array
    elsif next_char == '{'
      parse_hash
    else
      parse_value
    end
  end

  def parse_array
    # throw away the opening [
    @scan.getch

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
    # throw away the opening {
    @scan.getch

    retval = {}
    curr_key = nil
    while !@scan.eos?
      next_char = @scan.peek(1)
      if next_char == '}'
        # throw away the closing }
        @scan.getch
        break
      end
      # throw away the comma , or >
      @scan.getch if [',','>'].include?(next_char)

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

  def parse_value
    type_identifier = @scan.getch
    if type_identifier == 'b'
      @scan.getch == '1'
    elsif type_identifier == 'd'
      Date.strptime(get_chars(8), '%Y%m%d')
    elsif type_identifier == 'e'
      DateTime.strptime(get_chars(14), '%Y%m%d%H%M%S')
    elsif type_identifier == 't'
      Time.strptime(get_chars(14), '%Y%m%d%H%M%S')
    elsif type_identifier == 's'
      get_chars(@scan.scan_until(/:/).chop.to_i)
    elsif type_identifier == 'w'
      @scan.scan(/\d+/).to_i
    elsif type_identifier == 'c'
      BigDecimal(@scan.scan(/[0-9\.]+/))
    else
      raise "unexpected type identifier"
    end
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
