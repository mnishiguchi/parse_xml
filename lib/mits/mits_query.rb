require "active_support/all"
require "awesome_print"
require "json"
require "hashie"

require_relative "mits_query_finders.rb"

=begin
A feed parser that is used for parsing a feed xml into mits format.
It is used in Mits class.
---
Usage:
  properties = MitsQuery.all_properties_from(data)
  #=> array of properties
  NOTE: Data must not include the root key, namely "PhysicalProperty".
=end

module MitsQuery
  include MitsQueryFinders

  class Properties
    def self.from(data)
      results = []

      ["Property", "property"].each do |key|
        results << MitsQuery.deep_find_all_by_key(data, key)
      end

      results = results.flatten.uniq
    end
  end


  # ===
  # ===


  # Represents a single property. Finds data for each field of our property schema.
  # ---
  # Usage:
  #   MitsQuery::Property.new(a_property).address
  class Property

    def initialize(property_data)
      @property = property_data
    end

    # Returns all the values for the specified keys.
    def find_all_by_keys(*search_keys)
      results = []

      search_keys.each do |key|
        results << MitsQuery.deep_find_all_by_key(@property, key)
      end

      results = results.flatten.uniq
    end


    # ===
    # ===


    def address
      find_all_by_keys("Address").first || {}
    end

    def amenities
      find_all_by_keys("Amenities").first || {}
    end

    def email
      find_all_by_keys("Email").first || {}
    end

    def feed_uid
      find_all_by_keys("PropertyID").first || {}
    end

    def floorplans
      find_all_by_keys("Floorplans").first || {}
    end

    def information
      find_all_by_keys("Information").first || {}
    end

    def latitude
      find_all_by_keys("Latitude").first || {}
    end

    def lease_length
      find_all_by_keys("LeaseLength").first || {}
    end

    def longitude
      find_all_by_keys("Longitude").first || {}
    end

    def names
      find_all_by_keys("Name").first || {}
    end

    def office_hours
      find_all_by_keys("OfficeHours").first || {}
    end

    def parking
      find_all_by_keys("Parking").first || {}
    end

    def phones
      find_all_by_keys("phones").first || {}
    end

    def photos
      find_all_by_keys("photos").first || {}
    end

    def pet_policy
      find_all_by_keys("pet_policy").first || {}
    end

    def promotions
      find_all_by_keys("promotions").first || {}
    end

    def urls
      find_all_by_keys("urls").first || {}
    end

    def utilities
      find_all_by_keys("utilities").first || {}
    end
  end
end
