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
    # Finders for individual fields.
    # ---
    # - Output: Array of all that were found
    # ===

    def address
      results = find_all_by_keys("Address").compact.uniq
    end

    def amenities
      results = find_all_by_keys("Amenities").compact.uniq
    end

    def description
      results = find_all_by_keys("Description", "LongDescription").compact.uniq
    end

    def email
      results = find_all_by_keys("Email", "Lead2LeaseEmail").compact.uniq
    end

    def feed_uid
      results = find_all_by_keys("PropertyID", "PrimaryID").compact.uniq
    end

    def floorplans
      results = find_all_by_keys("Floorplan").compact.uniq
    end

    def information
      results = find_all_by_keys("Information").compact.uniq
    end

    def latitude
      results = find_all_by_keys("Latitude").compact.uniq
    end

    def lease_length
      results = find_all_by_keys("LeaseLength", "LeaseTerm").compact.uniq
    end

    def longitude
      results = find_all_by_keys("Longitude").compact.uniq
    end

    def name
      results = find_all_by_keys("MarketingName").compact.uniq
    end

    def office_hours
      results = find_all_by_keys("OfficeHours", "OfficeHour").compact.uniq
    end

    def parking
      results = []

      # Info from Amenities section if any.
      amenities = find_all_by_keys("Amenities").compact.uniq
      if amenities.size > 0
        amenities = amenities.first["General"]
        amenities.each { |hash| /park/i =~ hash.to_s }
        results << amenities
      end

      # Info from Parking section if any.
      results << find_all_by_keys("Parking").compact.uniq

      # Clean up and return the results.
      results.compact.flatten
    end

    def phones
      results = find_all_by_keys("Phone", "PhoneNumber").compact.uniq
    end

    def photos
      results = find_all_by_keys("File").compact.uniq
    end

    def pet_policy
      results = find_all_by_keys("Pet").compact.uniq
    end

    def promotions
      results = find_all_by_keys("Promotional").compact.uniq
    end

    def url
      results = find_all_by_keys("WebSite", "FloorplanAvailabilityURL", "PropertyAvailabilityURL")
      results.compact.uniq
    end

    def utilities
      # TODO: extract from Amenities.
      results = find_all_by_keys("Utility").compact.uniq
    end
  end
end
