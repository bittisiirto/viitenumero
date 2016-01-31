require 'test_helper'

class RFViiteTest < Minitest::Test
  def test_basic_cases
    [
      'RF332348236',
    ].each do |rf|
      assert RFViite.new(rf).valid?
    end

    [
      nil,
      '',
      '    ',
      '{}{R)@!#@$!$T >>',
      '1',
      '12',
      '123',
      '111',
      '999',
      '11111 11111 11111 11111 1',
      '11111 11111 11111 11111'
    ].each do |rf|
      assert !RFViite.new(rf).valid?
    end
  end

  def test_formatting
    assert_equal 'RF62917192622959197870', RFViite.new('RF62917192622959197870').machine_format
    assert_equal 'RF62 9171 9262 2959 1978 70', RFViite.new('RF62917192622959197870').paper_format
  end

  def test_to_s_defaults_to_machine_format
    assert_equal '917192622959197870', RFViite.new('917192622959197870').to_s
  end

  def test_generate
    assert_equal 'RF332348236', RFViite.generate('234823').to_s
    assert_raises(ArgumentError) { RFViite.generate(nil) }
    assert_raises(ArgumentError) { RFViite.generate('') }
    assert_raises(ArgumentError) { RFViite.generate('ABC') }
    assert_raises(ArgumentError) { RFViite.generate('11') }
    assert_raises(ArgumentError) { RFViite.generate('11111 11111 11111 11111 1') }
  end

  def test_random
    1000.times do
      assert_equal 8, RFViite.random(length: 8).to_s.length
    end
  end

  def test_checksum
    tests = [
      ['555', 'RF78 5555'],
      ['766', 'RF04 7663']
    ]

    tests.each do |test|
      assert_equal test[1], RFViite.generate(test[0]).paper_format
    end
  end
end
