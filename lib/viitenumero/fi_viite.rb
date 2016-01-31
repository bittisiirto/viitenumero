require 'active_model'

module Viitenumero
  class FIViite
    include ActiveModel::Validations

    attr_reader :number

    def initialize(s)
      @number = format(s)
    end

    def paper_format
      number.gsub(/.{5}(?=.)/, '\0 ')
    end

    def machine_format
      number
    end

    def valid?
      valid_format? and valid_length? and valid_checksum?
    end

    def self.generate(base)
      base = (base || '').to_s.gsub(/\s+/, '')
      raise ArgumentError.new('must be a number') if base.match(/\A\d+\z/).nil?
      raise ArgumentError.new('must be between 3-19 chars long') if base.length < 3 || base.length > 19

      FIViite.new(base + checksum(base))
    end

    def self.random(length: 4)
      raise ArgumentError if length < 4 || length > 20
      base = ''
      base_length = length - 1
      base = rand(10**base_length).to_s while base.length != base_length
      generate(base.to_s)
    end

    def self.valid?(s)
      FIViite.new(s).valid?
    end

    def to_s
      machine_format
    end

    def to_rf
      RFViite.generate(machine_format, add_fi_checksum: false)
    end

    private

    def format(s)
      r = (s || '').to_s.gsub(/\s+/, '')
      r.slice!(0) while r[0] == '0'
      r
    end

    def valid_format?
      !number.match(/\A\d+\z/).nil?
    end

    def valid_length?
      number.length >= 4 && number.length <= 20
    end

    def valid_checksum?
      last_digit = number[-1, 1]
      last_digit == self.class.checksum(number[0..-2])
    end

    def self.checksum(base)
      weights = [7, 3, 1]
      checksum, current_weight = 0, 0
      base.split('').reverse.each do |digit|
        checksum += digit.to_i * weights[current_weight % 3]
        current_weight += 1
      end
      ((10 - checksum % 10) % 10).to_s
    end
  end
end
