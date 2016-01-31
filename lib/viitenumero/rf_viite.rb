require 'active_model'

module Viitenumero
  # Note: Supports only ISO 11649 creditor references that are based on
  # Finnish national reference numbers (see fi_viite). Does *not* support
  # other SEPA countries.
  class RFViite
    include ActiveModel::Validations

    attr_reader :number

    def initialize(s)
      @number = format(s)
    end

    def paper_format
      number.gsub(/.{4}(?=.)/, '\0 ')
    end

    def machine_format
      number
    end

    def valid?
      valid_format? and valid_length? and valid_checksum? and valid_national_checksum?
    end

    def self.generate(base, add_fi_checksum: true)
      base = (base || '').to_s.gsub(/\s+/, '')
      raise ArgumentError.new('must be a number') if base.match(/\A\d+\z/).nil?
      raise ArgumentError.new('must be between 3-19 chars long') if base.length < 3 || base.length > 19

      base = base + FIViite.checksum(base) if add_fi_checksum
      RFViite.new('RF' + checksum(base) + base)
    end

    def self.random(length: 8)
      raise ArgumentError if length < 8 || length > 24
      base_length = length - 4
      FIViite.random(length: base_length).to_rf
    end

    def self.valid?(s)
      RFViite.new(s).valid?
    end

    def to_s
      machine_format
    end

    def to_fi
      FIViite.new(national_part)
    end

    def national_part
      number[4..-1]
    end

    private

    def format(s)
      (s || '').to_s.gsub(/\s+/, '').upcase
    end

    def valid_format?
      !number.match(/\ARF\d+\z/).nil?
    end

    def valid_length?
      number.length >= 8 && number.length <= 24
    end

    def valid_checksum?
      check_digits = number[2..3]
      check_digits == self.class.checksum(national_part)
    end

    def valid_national_checksum?
      FIViite.valid?(national_part)
    end

    def self.checksum(base)
      (98 - (base + '271500').to_i % 97).to_s.rjust(2, '0')
    end
  end
end
