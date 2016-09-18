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
    # *filters - unlimited args of filter lambdas.
    # Usage:
    #   fix!(
    #     ->(k, v) { /n\/a/i =~ v ? [k, ""] : [k, v] },
    #     ->(k, v) { /address/i =~ k ? ["Address", v] : [k, v] },
    #   )
    def fix!(*filters)
      filters.each { |filter| @data = @data.map(&filter) }
      @data = Hash[@data]
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
      fix!(
        ->(k, v) { /n\/a/i =~ v ? [k, ""] : [k, v] },
        ->(k, v) { /address/i =~ k ? ["Address", v] : [k, v] },
        ->(k, v) { /county/i =~ k ? ["County", v] : [k, v] },
        ->(k, v) { /zip/i =~ k || /postal/i =~ k ? ["Zip", v] : [k, v] },
      )

      # Determine a value for each key.
      @address  = @data["Address"]
      @city     = @data["City"]
      @county   = @data["County"]
      @zip      = @data["Zip"]
      @state    = @data["State"]
      @country  = @data["Country"]
      @po_box   = @data["PO_Box"]
    end
  end

  # class Amenities < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = data["menities"].to_json
  #   end
  # end
  #
  # class Community < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = data["amenities"]["community"]
  #   end
  # end
  #
  # class Emails < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = data["emails"].values
  #   end
  # end
  #
  # class Description < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = "Lorem"
  #   end
  # end
  #
  # class Floorplans < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = data["floorplans"].to_json
  #   end
  # end
  #
  # class Latitude < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = data["latitude"]
  #   end
  # end
  #
  # class Longitude < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = data["longitude"]
  #   end
  # end
  #
  # class Parking < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = data["parking"]
  #   end
  # end
  #
  # class PetPolicy < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = data["pet_policy"].to_json
  #   end
  # end
  #
  # class Phones < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = data["phones"].to_json
  #   end
  # end
  #
  # class PrimaryName < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = data["primary_name"]
  #   end
  # end
  #
  # class Photos < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = data["photos"].to_json
  #   end
  # end
  #
  # class Uid < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = data["uniq_id"]
  #   end
  # end
  #
  # class Urls < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = data["urls"].to_json
  #   end
  # end
  #
  # class Utility < MitsFormatter::Base
  #   def initialize(data)
  #     super(data)
  #     @value = data["utility"].to_json
  #   end
  # end
end
