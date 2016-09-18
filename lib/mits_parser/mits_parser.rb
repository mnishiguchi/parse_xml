require "active_support/all"
require "awesome_print"
require "json"
require "hashie"

require_relative "./mits_field.rb"

=begin
A feed parser that is used for parsing a feed xml into mits format.
It is used in Mits class.

Usage:
  MitsParser.parse_properties(json_hash).each do |property_hash|
    floorplan_hashes = property_hash.delete(:floorplans).reject { |value| value == {} }
    # ...
  end


Input:
  - feed hash (NOTE: It must not include the root node, namely "PhysicalProperty")
Process:
  - Sanitize special fields.
Output:
  - Sanitized feed hash that can be available in the specified information.


My plan for restructuring:
  Invokation
    mits = MitsParser.new(data)         #==> Create a parser for a given feed
                                        #==> Sanitized feed for mits
    mits.properties                     #==> An array of property hashes

  Methodology
    MitsParser internally
      1. Divide the properties into objects
      2. Sanitize data
      3. Reconstruct as json
=end

class MitsParser

  ARRAY_NODE = "Array"

  def initialize(data)
    @data = data
  end


  # ===
  # Utility methods
  # ===


  # Retrieves the value object of the specified paths.
  # data - hash, array or string
  # default_value
  # paths - an array of string arrays [["", ""], ["", ""]]
  # returns the value of the first occurrence if any.
  def self.find_first(data, *paths)
    paths.each do |path|
      result = MitsParser.find(data, path)
      result = result.compact.flatten if result.is_a?(Array)
      return result unless result.blank?
    end
    nil
  end

  # Retrieves the value object of the specified paths.
  # data - hash, array or string
  # paths - arrays of strings ["", ""], ["", ""]
  # returns a hash of result
  def self.find_all(data, *paths)
    results = []

    paths.each do |path|
      result = MitsParser.find(data, path)
      result = result.compact.flatten if result.is_a?(Array)

      # Store data as a path-value pair.
      results << [path.join('/'), result] unless result.blank?
    end

    results.to_h
  end

  # Retrieves the value object of the specified path.
  # data - hash, array or string
  # path  - an array of strings ["", ""]
  # returns value if any datatype e.g., [], {}, "some value", { key: value, key: value }
  # ---
  # NOTE: This method does something similar to what Hash#dig does but
  # the difference is this method proceed recursively even if the data is an array.
  def self.find(data, path)
    # Ensure args are of proper data types.
    unless data.is_a?(String) || data.is_a?(Array) || data.is_a?(Hash)
      raise ArgumentError.new("data must be an string, array or hash")
    end

    raise ArgumentError.new("path must be an array") unless path.is_a?(Array)

    # Base case:
    return data if path.empty?

    # Pop a node from the path list.
    current_node, remaining_path = path[0], path[1..-1]

    # Continue the process.
    if current_node == ARRAY_NODE
      # Recurse on all the nodes in the array.
      data.map { |d| MitsParser.find(d, remaining_path) }
    elsif data.is_a?(Hash) && data[current_node]
      # If data is a hash, recurse on the remaining path.
      MitsParser.find(data[current_node], remaining_path)
    else
      data
    end
  end

  def self.all_variants(string)
    [string.singularize, string.pluralize].map do |s|
      [s.titleize, s.camelize, s.underscore, s.tableize, s.humanize]
    end.flatten.uniq
  end

  # Returns array of values.
  def self.deep_find_all_by_key(data, key)
    data.extend Hashie::Extensions::DeepFind
    data.deep_find_all(key)
  end

  # Returns array of key-value pairs(hashes).
  def self.deep_locate_all_by_key(data, key)
    data.extend Hashie::Extensions::DeepLocate
    results = data.deep_locate -> (k, v, object) { k == key && v.present? }
    results.uniq!
  end


  # ===
  # Find data for each field
  # ===


  def self.find_address(data)
    results = []

    search_keys = [
      "Address",
      "address"
    ]

    search_keys.each do |key|
      results << MitsParser.deep_find_all_by_key(data, key)
    end

    results = results.flatten.uniq
  end





  # ===
  # Property
  # ===


  # Usage:
  #   MitsParser::Property.new(data)
  class Property
    attr_reader(
      :address,
      :amenities,
      :descriptions,
      :emails,
      :feed_uid,
      :floorplans,
      :information,
      :names,
      :latitude,
      :lease_length,
      :longitude,
      :office_hours,
      :parking,
      :phones,
      :photo_urls,
      :pet_policy,
      :promotional_info,
      :urls,
      :utilities
    )

    def initialize(data)
      # Ensure args are of proper data types.
      unless data.is_a?(Array) || data.is_a?(Hash)
        raise ArgumentError.new("data must be an array or hash")
      end

      @address          = MitsField::Address.new(data).value
      # @amenities        = MitsField::Amenities.new(data).value
      # @descriptions     = MitsField::Descriptions.new(data).value
      # @emails           = MitsField::Emails.new(data).value
      # @feed_uid         = MitsField::FeedUid.new(data).value
      # @floorplans       = MitsField::Floorplans.new(data).value
      # @information      = MitsField::Information.new(data).value
      # @names            = MitsField::Names.new(data).value
      # @latitude         = MitsField::Latitude.new(data).value
      # @lease_length     = MitsField::LeaseLength.new(data).value
      # @longitude        = MitsField::Longitude.new(data).value
      # @office_hours     = MitsField::OfficeHours.new(data).value
      # @parking          = MitsField::Parking.new(data).value
      # @phones           = MitsField::Phones.new(data).value
      # @photos           = MitsField::Photos.new(data).value
      # @pet_policy       = MitsField::PetPolicy.new(data).value
      # @promotions       = MitsField::Promotions.new(data).value
      # @urls             = MitsField::Urls.new(data).value
      # @utilities        = MitsField::Utilities.new(data).value
      freeze
    end
  end
end
