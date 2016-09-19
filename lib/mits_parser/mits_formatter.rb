=begin
The MitsFormatter class provides us with a single location to
configure each fields of the Properties table. Its initializer
takes a feed data. We create subclasses of the Base class that
correspond to the Property model's column names and specify how
to determine the value for each field.
Usage:
  address = MitsFormatter::Address.new(data)
=end

module MitsFormatter

  class Base
    attr_reader :data

    def initialize(data)
      raise "data must be array or hash" unless data.is_a?(Array) || data.is_a?(Hash)
      @data = data
    end

    # Applies to @data the specified filters to format the data.
    # filters - unlimited args of filter lambdas.
    # Usage:
    #   format!(
    #     ->(k, v) { /n\/a/i =~ v ? [k, ""] : [k, v] },
    #     ->(k, v) { /address/i =~ k ? ["Address", v] : [k, v] },
    #   )
    def format!(*filters)
      filters.each { |filter| @data = @data.map(&filter) }
      @data = Hash[@data]
      self
    end

    def format_at!(key, *filters)
      data_at_key = @data[key]
      return self unless data_at_key

      # puts "------Before------"
      # ap data_at_key

      filters.each { |filter| data_at_key = data_at_key.map(&filter) }
      @data[key] = Hash[data_at_key]

      # puts "------After------"
      # ap @data[key]

      self
    end
  end


  # ===
  # Subclasses that correspond to the Properties table's column names.
  # ===


  class Address < MitsFormatter::Base
    def initialize(data)
      super(data)

      # Replaces "N/A" with "".
      # Standardizes on the "Address" key for the street address.
      # Standardizes on the "County" key for the county.
      # Standardizes on the "Zip" key for the zipcode.
      format!(
        ->(k, v) { /n\/a/i =~ v ? [k, ""] : [k, v] },
        ->(k, v) { /address/i =~ k ? ["Address", v] : [k, v] },
        ->(k, v) { /county/i =~ k ? ["County", v] : [k, v] },
        ->(k, v) { /zip/i =~ k || /postal/i =~ k ? ["Zip", v] : [k, v] },
      )
    end
  end

  class Amenities < MitsFormatter::Base
    def initialize(data)
      super(data)

      format_at!("Community",
        ->(k, v) { /Availab.*24.*/i =~ k ? [k, "AlwaysAvailable"] : [k, v] },
      )

      format_at!("Floorplan",
        ->(k, v) { /WD_Hookup/i =~ k ? ["WasherDryerHookup", v] : [k, v] },
        ->(k, v) { /true|t|1/i =~ v ? [k, "true"] : [k, v] },
        ->(k, v) { /false|f|0/i =~ v ? [k, "false"] : [k, v] },
      )
    end
  end

  class Descriptions < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["descriptions"]
    end
  end

  class Emails < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["emails"]
    end
  end

  class Description < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = "Lorem"
    end
  end

  class Floorplans < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["floorplans"].to_json
    end
  end

  class Information < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["information"].to_json
    end
  end

  class Latitude < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["latitude"]
    end
  end

  class Longitude < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["longitude"]
    end
  end

  class Names < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["names"]
    end
  end

  class Parking < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["parking"]
    end
  end

  class PetPolicy < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["pet_policy"].to_json
    end
  end

  class Phones < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["phones"].to_json
    end
  end

  class PrimaryName < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["primary_name"]
    end
  end

  class Photos < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["photos"].to_json
    end
  end

  class FeedUid < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["uniq_id"]
    end
  end

  class Urls < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["urls"].to_json
    end
  end

  class Utility < MitsFormatter::Base
    def initialize(data)
      super(data)
      @value = data["utility"].to_json
    end
  end
end