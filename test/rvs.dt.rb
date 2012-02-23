require_relative '../lib/rvs/parse'
require_relative '../lib/rvs/to_rvs'

class Test_rvs < DohTest::TestGroup
  def verify(original_obj, expected_str)
    actual_str = original_obj.to_rvs
    assert_equal(expected_str, actual_str)
    recreated_obj = RVS::parse(actual_str)
    assert_equal(original_obj, recreated_obj)
  end

  def test_whole_numbers
    fixnum = 1000
    assert(fixnum.is_a?(Fixnum))
    verify(fixnum, 'w1000')

    bignum = 9999999999999999999999999999999
    assert(bignum.is_a?(Bignum))
    verify(bignum, 'w9999999999999999999999999999999')
  end

  def test_boolean
    verify(true, 'b1')
    verify(false, 'b0')
  end

  def test_bigdecimal
    verify(BigDecimal('100'), 'c100.0')
    verify(BigDecimal('100.14'), 'c100.14')
    verify(BigDecimal('100.143912981212381923'), 'c100.143912981212381923')
  end

  def test_date
    verify(Date.new(2012,2,9), 'd20120209')
  end

  def test_datetime
    verify(DateTime.new(2012,2,9,1,5,7), 'e20120209010507')
    verify(DateTime.new(2012,2,9,17,39,45), 'e20120209173945')
  end

  def test_time
    verify(Time.new(2012,2,9,1,5,7), 't20120209010507')
    verify(Time.new(2012,2,9,17,39,45), 't20120209173945')
  end

  def test_array
    verify([1, 2], '[w1,w2]')
    verify([1, [2,3]], '[w1,[w2,w3]]')
    verify([1, [2,[3,4]]], '[w1,[w2,[w3,w4]]]')
  end

  def test_hash
    verify({1 => 2}, '{w1>w2}')
    verify({1 => 2, 3 => 4}, '{w1>w2,w3>w4}')
    verify({1 => 2, 3 => {4 => 5}}, '{w1>w2,w3>{w4>w5}}')
  end

  def test_mixed
    verify({1 => ['blah'], ['blee',nil] => {4 => 5}}, '{w1>[s4:blah],[s4:blee,z]>{w4>w5}}')
  end

  def test_nil
    verify(nil, 'z')
  end

  def test_string
    verify('', 's0:')
    verify('blah', 's4:blah')
    verify('blahblee', 's8:blahblee')
    verify('blahb\'lee', "s9:blahb'lee")
    verify('blahb\'le"e', %q{s10:blahb'le"e})
  end
end
