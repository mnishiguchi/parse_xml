=begin
The MitsField class provides us with a single location to
configure each fields of the Properties table. Its initializer
takes a feed data. We create subclasses of the Base class that
correspond to the Property model's column names and specify how
to determine the value for each field.
Usage:
  address = MitsField::Address.new(data)
=end

module MitsField

  class Base
    attr_reader :value

    # Public API. Takes in an array of data for a given field.
    # Returns a processed data as value.
    def self.from(data)
      new(data).value
    end

    protected

      def initialize(data)
        raise "data must be array" unless data.is_a?(Array) # || data.is_a?(Hash)
        @value = data
      end

      # Applies to @value the specified filters to format the data.
      # filters - an array of filter lambdas.
      # Usage:
      #   format_root!(
      #     ->(k, v) { /n\/a/i =~ v ? [k, ""] : [k, v] },
      #     ->(k, v) { /address/i =~ k ? ["Address", v] : [k, v] },
      #   )
      def format_root!(filters)
        return unless @value.is_a? Hash
        filters.each { |filter| @value = @value.map(&filter) }
        @value = Hash[@value]
      end

      def format_children!(key, filters)
        return unless @value.is_a? Hash

        data_at_key = @value[key]
        return self unless data_at_key

        # puts "------Before------"
        # ap data_at_key

        filters.each { |filter| data_at_key = data_at_key.map(&filter) }
        @value[key] = Hash[data_at_key]

        # puts "------After------"
        # ap @value[key]
        # puts "------End Format------"
      end

      # TODO
      def format_recursively!(key, filters)
      end

      def replace_key(regex, new_key)
        ->(k, v) { regex =~ k ? [new_key, v] : [k, v] }
      end

      def replace_value(regex, new_value)
        ->(k, v) { regex =~ v ? [k, new_value] : [k, v] }
      end
  end


  # ===
  # Subclasses that correspond to the Properties table's column names.
  # ===


  class Address < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data.first

      # Replaces "N/A" with "".
      # Standardizes on the "Address" key for the street address.
      # Standardizes on the "County" key for the county.
      # Standardizes on the "Zip" key for the zipcode.
      format_root! [
        replace_key(/address/i, "Address"),
        replace_key(/county/i, "County"),
        replace_key(/zip|postal/i, "Zip"),
        replace_value(/n\/a/i , "")
      ]
    end
  end

  class Amenities < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data.first

      format_children! "Community", [
        replace_key(/Availab.*24.*/i, "AlwaysAvailable")
      ]

      format_children! "Floorplan", [
        replace_key(/WD_Hookup/i, "WasherDryerHookup"),
        replace_value(/true|t|1/i, "true"),
        replace_value(/false|f|0/i, "false")
      ]
    end
  end

  class Description < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data.first
    end
  end

  class Email < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data.first
    end
  end

  class FeedUid < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data.first
    end
  end

  class Floorplans < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data
    end
  end

  class Information < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data.first
    end
  end

  class Latitude < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data.first
    end
  end

  class LeaseLength < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      lease_length = data.first
      if lease_length.is_a?(String)
        @value = { min: lease_length, max: nil }
      elsif lease_length.is_a?(Hash) && lease_length["Min"]
        @value = { min: lease_length["Min"], max: lease_length["Max"] }
      end
    end
  end

  class Longitude < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data.first
    end
  end

  class Name < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data.first
    end
  end

  class OfficeHours < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      json = data.to_json
      json.gsub!(/sunday/i, "Sunday")
      json.gsub!(/monday/i, "Monday")
      json.gsub!(/tuesday/i, "Sunday")
      json.gsub!(/wednesday/i, "Wednesday")
      json.gsub!(/thursday/i, "Thursday")
      json.gsub!(/friday/i, "Friday")
      json.gsub!(/saturday/i, "Saturday")
      @value = JSON.parse(json)
    end
  end

  class Parking < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data
    end
  end

  class PetPolicy < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data
    end
  end

  class Phones < MitsField::Base
    def initialize(data)
      super(data)

      # Extract phone number from data.
      @value = data.first
      @value = data.to_s.scan(/\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})/).join("-")
    end
  end

  class Photos < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data
    end
  end

  class Promotions < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data
    end
  end

  class Url < MitsField::Base
    def initialize(data)
      super(data)

      # Extract a value  we want from the data.
      @value = data.first
    end
  end

  class Utilities < MitsField::Base
    def initialize(data)
      super(data)

      # TODO: What data comes here?

      # Extract a value  we want from the data.
      @value = data
    end
  end
end
