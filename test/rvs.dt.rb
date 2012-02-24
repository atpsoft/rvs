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
    verify(fixnum, '1000')

    bignum = 9999999999999999999999999999999
    assert(bignum.is_a?(Bignum))
    verify(bignum, '9999999999999999999999999999999')
  end

  def test_boolean
    verify(true, 'true')
    verify(false, 'false')
  end

  def test_bigdecimal
    verify(BigDecimal('100'), 'c100.0')
    verify(BigDecimal('100.14'), 'c100.14')
    verify(BigDecimal('100.143912981212381923'), 'c100.143912981212381923')
  end

  def test_date
    verify(Date.new(2012,2,9), 'd2012-02-09')
  end

  def test_datetime
    verify(DateTime.new(2012,2,9,1,5,7), 'd2012-02-09 01:05:07')
    verify(DateTime.new(2012,2,9,17,39,45), 'd2012-02-09 17:39:45')
  end

  def test_time
    verify(Time.new(2012,2,9,1,5,7), 't2012-02-09 01:05:07')
    verify(Time.new(2012,2,9,17,39,45), 't2012-02-09 17:39:45')
  end

  def test_array
    verify([1, 2], '[1,2]')
    verify([1, [2,3]], '[1,[2,3]]')
    verify([1, [2,[3,4]]], '[1,[2,[3,4]]]')
  end

  def test_hash
    verify({1 => 2}, '{1>2}')
    verify({1 => 2, 3 => 4}, '{1>2,3>4}')
    verify({1 => 2, 3 => {4 => 5}}, '{1>2,3>{4>5}}')
  end

  def test_mixed
    verify({1 => ['blah'], ['blee',nil] => {4 => 5}}, '{1>["blah"],["blee",nil]>{4>5}}')
  end

  def test_nil
    verify(nil, 'nil')
  end

  def test_nonempty_string_following_empty_string
    verify(['', 'blah'], '["","blah"]')
  end

  def test_string
    verify('', %q{""})
    verify('blah', %q{"blah"})
    verify('blahblee', %q{"blahblee"})
    verify('blahb\'lee', %q{"blahb'lee"})
    # verify('blahb\'le"e', %q{"blahb'le"e""})
  end
end
