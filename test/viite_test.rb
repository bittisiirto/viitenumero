require 'test_helper'

class ViiteTest < Minitest::Test
  def test_basic_cases
    [
      '1313',
      '2121',
      '4242',
      '5555',
      '1009',
      '61 74354',
      '917192622959197870',
      '200 30094 31000 74836'
    ].each do |rf|
      assert Viite.new(rf).valid?
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
      assert !Viite.new(rf).valid?
    end
  end

  def test_formatting
    assert_equal '917192622959197870', Viite.new('917192622959197870').machine_format
    assert_equal '91719 26229 59197 870', Viite.new('917192622959197870').paper_format
  end

  def test_to_s_defaults_to_machine_format
    assert_equal '917192622959197870', Viite.new('917192622959197870').to_s
  end

  def test_generate
    assert_equal '1009', Viite.generate('100').to_s
    assert_raises(ArgumentError) { Viite.generate(nil) }
    assert_raises(ArgumentError) { Viite.generate('') }
    assert_raises(ArgumentError) { Viite.generate('ABC') }
    assert_raises(ArgumentError) { Viite.generate('11') }
    assert_raises(ArgumentError) { Viite.generate('11111 11111 11111 11111') }
  end

  def test_random
    1000.times do
      assert_equal 4, Viite.random(length: 4).to_s.length
    end
  end

  def test_checksum
    tests = [
      ['100', '1009'],
      ['101', '1012'],
      ['102', '1025'],
      ['103', '1038'],
      ['104', '1041'],
      ['105', '1054'],
      ['106', '1067'],
      ['107', '1070'],
      ['108', '1083'],
      ['109', '1096'],
      ['110', '1106'],
      ['111', '1119'],
      ['112', '1122'],
      ['113', '1135'],
      ['114', '1148'],
      ['115', '1151'],
      ['116', '1164'],
      ['117', '1177'],
      ['118', '1180'],
      ['119', '1193'],
      ['100000000', '10000 00009'],
      ['100000001', '10000 00012'],
      ['100000002', '10000 00025'],
      ['100000003', '10000 00038'],
      ['100000004', '10000 00041'],
      ['100000005', '10000 00054'],
      ['100000006', '10000 00067'],
      ['100000007', '10000 00070'],
      ['100000008', '10000 00083'],
      ['100000009', '10000 00096'],
      ['100000010', '10000 00106']
    ]

    tests.each do |test|
      assert_equal test[1], Viite.generate(test[0]).paper_format
    end
  end
end
