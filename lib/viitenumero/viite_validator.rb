module Viitenumero
	class ViiteValidator < ActiveModel::EachValidator
	  def validate_each(record, attribute, value)
	    record.errors[attribute] << (options[:message] || 'on virheellinen') unless Viite.valid?(value)
	  end
	end
end