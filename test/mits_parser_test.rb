require "active_support/all"
require "awesome_print"
require 'open-uri'
require 'pry'
require 'test_helper'
require 'support/webmock'

require_relative "../lib/mits_parser.rb"

describe MitsParser do

  def valid_json?(json)
    begin
      JSON.parse(json)
      return true
    rescue Exception => e
      return false
    end
  end

  before do

    # Check currently working directory.
    puts "Dir.pwd: #{Dir.pwd}"

    # Read an example xml data.
    xml = open("#{Dir.pwd}/test/fixtures/files/bozzuto.xml") { |io| io.read }

    ap xml
    #
    # @property_hash = "TODO"


  end

  it "example test" do

    # binding.pry

    puts "end of the example test"
  end

  # describe ".dig(hash, paths)" do
  #
  #   describe "when first argument is nil" do
  #     subject { MitsParser.dig(nil, ["Property"]) }
  #
  #     it "returns {}" do
  #       assert_equal({}, subject)
  #     end
  #   end
  #
  #   describe "when first argument is non-hash type" do
  #     subject { MitsParser.dig("hello", ["Property"]) }
  #
  #     it "returns []" do
  #       assert_equal([], subject)
  #     end
  #   end
  #
  #   describe "when the path array is empty" do
  #     subject { MitsParser.dig(@property_hash, []) }
  #
  #     it "returns the same hash that was passed in" do
  #       assert_equal(@property_hash, subject)
  #     end
  #   end
  #
  #   describe "when the path is non-array" do
  #     subject { MitsParser.dig(@property_hash, "non-array object") }
  #
  #     it "raises an exception" do
  #       assert_raises(Exception)
  #     end
  #   end
  # end

  #########

  # it ".dig_all(hash, set_of_paths)" do
  #   set_of_paths = [
  #     ["primary_name"],
  #     ["latitude"],
  #     ["longitude"]
  #   ]
  #   expected = {
  #     primary_name: "Westside Creek",
  #     latitude:     "34.80",
  #     longitude:    "-92.42"
  #   }
  #   assert_equal(expected, MitsParser.dig_all(@property_hash, *set_of_paths))
  # end

  # it ".dig_any(hash, default_value, *set_of_paths)" do
  #   set_of_paths = [
  #     ["primary_name"],
  #     ["latitude"],
  #     ["longitude"]
  #   ]
  #   expected = {
  #     primary_name: "Westside Creek",
  #     latitude:     "34.80",
  #     longitude:    "-92.42"
  #   }
  #   assert_equal(expected, MitsParser.dig_any(@property_hash, "", *set_of_paths))
  # end
end
