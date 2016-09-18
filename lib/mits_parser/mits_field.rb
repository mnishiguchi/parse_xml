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
    def initialize(data)
      raise "Must be array or hash" unless data.is_a?(Array) || data.is_a?(Hash)
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


  class Address < MitsField::Base
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

  # class Amenities < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = data["menities"].to_json
  #   end
  # end
  #
  # class Community < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = data["amenities"]["community"]
  #   end
  # end
  #
  # class Emails < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = data["emails"].values
  #   end
  # end
  #
  # class Description < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = "Lorem"
  #   end
  # end
  #
  # class Floorplans < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = data["floorplans"].to_json
  #   end
  # end
  #
  # class Latitude < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = data["latitude"]
  #   end
  # end
  #
  # class Longitude < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = data["longitude"]
  #   end
  # end
  #
  # class Parking < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = data["parking"]
  #   end
  # end
  #
  # class PetPolicy < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = data["pet_policy"].to_json
  #   end
  # end
  #
  # class Phones < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = data["phones"].to_json
  #   end
  # end
  #
  # class PrimaryName < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = data["primary_name"]
  #   end
  # end
  #
  # class Photos < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = data["photos"].to_json
  #   end
  # end
  #
  # class Uid < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = data["uniq_id"]
  #   end
  # end
  #
  # class Urls < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = data["urls"].to_json
  #   end
  # end
  #
  # class Utility < MitsField::Base
  #   def initialize(data)
  #     super
  #     @value = data["utility"].to_json
  #   end
  # end
end
