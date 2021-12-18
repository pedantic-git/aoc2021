#!/usr/bin/env ruby

class Packet
  
  attr_reader :bits, :version, :type, :literal, :subpackets
  
  def initialize(bits)
    @bits = bits
    @subpackets = []
    parse!
  end
  
  def version_sum
    version + subpackets.sum(&:version_sum)
  end
  
  def value
    case type
    when 0
      subpackets.map(&:value).sum
    when 1
      subpackets.map(&:value).reduce(&:*)
    when 2
      subpackets.map(&:value).min
    when 3
      subpackets.map(&:value).max
    when 4
      literal
    when 5
      subpackets[0].value > subpackets[1].value ? 1 : 0
    when 6
      subpackets[0].value < subpackets[1].value ? 1 : 0
    when 7
      subpackets[0].value == subpackets[1].value ? 1 : 0
    end
  end
  
  def to_s
    case type
    when 0
      "(#{subpackets.map(&:to_s).join(' + ')})"
    when 1
      "(#{subpackets.map(&:to_s).join(' * ')})"
    when 2
      "min(#{subpackets.map(&:to_s).join(', ')})"
    when 3
      "max(#{subpackets.map(&:to_s).join(', ')})"
    when 4
      literal
    when 5
      "(#{subpackets.map(&:to_s).join ' > '})"
    when 6
      "(#{subpackets.map(&:to_s).join ' < '})"
    when 7
      "(#{subpackets.map(&:to_s).join ' == '})"
    end
  end
  
  private
  
  def parse!
    @version = get_int(3)
    case @type = get_int(3)
    when 4
      @literal = get_literal
    else
      @subpackets = get_subpackets
    end
  end
  
  # Get an integer with the next n bits
  def get_int(n)
    bits.shift(n).join('').to_i(2)
  end
  
  # Get a literal value off the top of bits
  def get_literal
    str = ""
    loop do
      next_five = bits.shift(5)
      str += next_five[1..].join
      break if next_five[0] == '0'
    end
    str.to_i(2)
  end
  
  # Get the subpackets of this packet
  def get_subpackets
    if get_int(1) == 0
      length = get_int(15)
      new_bits = bits.shift(length)
      [].tap do |packets|
        until new_bits.length < 11
          packets << Packet.new(new_bits)
        end
      end
    else
      num = get_int(11)
      # share the 'bits' directly so it gets chopped up by this
      # iteration
      num.times.map { Packet.new(bits) }
    end
  end 
  
end

INPUT = ARGV.shift || "2056FA18025A00A4F52AB13FAB6CDA779E1B2012DB003301006A35C7D882200C43289F07A5A192D200C1BC011969BA4A485E63D8FE4CC80480C00D500010F8991E23A8803104A3C425967260020E551DC01D98B5FEF33D5C044C0928053296CDAFCB8D4BDAA611F256DE7B945220080244BE59EE7D0A5D0E6545C0268A7126564732552F003194400B10031C00C002819C00B50034400A70039C009401A114009201500C00B00100D00354300254008200609000D39BB5868C01E9A649C5D9C4A8CC6016CC9B4229F3399629A0C3005E797A5040C016A00DD40010B8E508615000213112294749B8D67EC45F63A980233D8BCF1DC44FAC017914993D42C9000282CB9D4A776233B4BF361F2F9F6659CE5764EB9A3E9007ED3B7B6896C0159F9D1EE76B3FFEF4B8FCF3B88019316E51DA181802B400A8CFCC127E60935D7B10078C01F8B50B20E1803D1FA21C6F300661AC678946008C918E002A72A0F27D82DB802B239A63BAEEA9C6395D98A001A9234EA620026D1AE5CA60A900A4B335A4F815C01A800021B1AE2E4441006A0A47686AE01449CB5534929FF567B9587C6A214C6212ACBF53F9A8E7D3CFF0B136FD061401091719BC5330E5474000D887B24162013CC7EDDCDD8E5E77E53AF128B1276D0F980292DA0CD004A7798EEEC672A7A6008C953F8BD7F781ED00395317AF0726E3402100625F3D9CB18B546E2FC9C65D1C20020E4C36460392F7683004A77DB3DB00527B5A85E06F253442014A00010A8F9106108002190B61E4750004262BC7587E801674EB0CCF1025716A054AD47080467A00B864AD2D4B193E92B4B52C64F27BFB05200C165A38DDF8D5A009C9C2463030802879EB55AB8010396069C413005FC01098EDD0A63B742852402B74DF7FDFE8368037700043E2FC2C8CA00087C518990C0C015C00542726C13936392A4633D8F1802532E5801E84FDF34FCA1487D367EF9A7E50A43E90"
bits = [INPUT].pack("H*").unpack('B*').first.split('')

b = Packet.new(bits)
puts "#{b} => #{b.value}"
