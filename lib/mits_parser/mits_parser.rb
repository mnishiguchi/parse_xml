require "active_support/all"
require "awesome_print"
require "json"
require "hashie"

=begin
A feed parser that is used for parsing a feed xml into mits format.
It is used in Mits class.
---
Usage:
  MitsParser.new(@property_data).find_all_properties
  #=> array of properties
---
Input:
  - feed hash (NOTE: It must not include the root node, namely "PhysicalProperty")
Output:
  - Sanitized feed hash that can be available in the specified information.
---
Purposes:
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
  # Find all the properties from @data.
  # ===


  def find_all_properties
    results = []

    search_keys = [
      "Property",
      "property"
    ]

    search_keys.each do |key|
      results << MitsParser.deep_find_all_by_key(@data, key)
    end

    results = results.flatten.uniq
  end


  # ===
  # ===


  # Represents a single property.
  # Finds data for each field.
  # ---
  # Usage:
  #   MitsParser::Property.new(properties.first).address
  class Property

    def initialize(property_data)
      @property = property_data
    end

    # data - data of a SINGLE property
    # returns an address that was found first.
    def address
      results = []

      search_keys = [
        "Address",
        "address"
      ]

      search_keys.each do |key|
        results << MitsParser.deep_find_all_by_key(@property, key)
      end

      results = results.flatten.uniq
      results.first
    end
  end
end
