require 'active_model'

module Viitenumero
  class Viite
    include ActiveModel::Validations

    attr_reader :number

    def initialize(s)
      if FIViite.valid?(s)
        @number = FIViite.new(s)
      elsif RFViite.valid?(s)
        @number = RFViite.new(s)
      else
        @number = FIViite.new(s)
      end
    end

    def rf
      number.is_a?(RFViite) ? number : number.to_rf
    end

    def fi
      number.is_a?(FIViite) ? number : number.to_fi
    end

    def paper_format
      number.paper_format
    end

    def machine_format
      number.machine_format
    end

    def valid?
      number.valid?
    end

    def self.valid?(s)
      Viite.new(s).valid?
    end

    def to_s
      machine_format
    end
  end
end
