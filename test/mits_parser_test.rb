require 'awesome_print'
require 'pry'
require 'test_helper'
require 'support/active_support'
require 'support/webmock'

require_relative "../lib/mits_parser/mits_parser.rb"

# The path to the 'fixture/files' directory
FILE_DIR = "#{Dir.pwd}/test/fixtures/files"

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
    # The absolute path to the source XML file.
    path = File.join(FILE_DIR, "boz.xml")

    # Read an example xml data.
    xml = File.read(path)


    @property_data = Hash.from_xml(xml)["PhysicalProperty"]

    # ap @property_data["Property"][0]["Information"]["FacebookURL"]

  end


  # ===
  # ===


  describe ".find(data, path)" do

    it "Property/Array/Information/FacebookURL" do
      path     = ["Property", "Array", "Information", "FacebookURL"]
      expected = ["http://www.facebook.com/LakesideVA", "http://www.facebook.com/metropointeapts"]
      assert_equal(expected, MitsParser.find(@property_data, path))
    end

    describe "data" do
      describe "when data is nil" do
        subject { MitsParser.find(nil, ["Property"]) }

        it "raises an exception" do
          assert_raises(Exception)
        end
      end

      describe "when passed in as a generic object" do
        subject { MitsParser.find(Object.new, ["Property"]) }

        it "raises an exception" do
          assert_raises(Exception)
        end
      end

      describe "when passed in as a string" do
        subject { MitsParser.find("hello", ["Property"]) }

        it "returns the unprocessed data" do
          assert_equal("hello", subject)
        end
      end
    end

    describe "path" do

      describe "when passed in as non-array type" do
        subject { MitsParser.find(@property_data, "non-array object") }

        it "raises an exception" do
          assert_raises(Exception)
        end
      end

      describe "when passed in as empty path" do
        subject { MitsParser.find(@property_data, []) }

        it "returns the unprocessed data" do
          assert_equal(@property_data, subject)
        end
      end

    end
  end


  # ===
  # ===


  describe ".find_all(data, paths)" do

    it "returns correct result as a hash" do
      result_hash = MitsParser.find_all(@property_data,
      ["Property", "Array", "Information", "FacebookURL"]
      )
      expected = {
        "Property/Array/Information/FacebookURL" => ["http://www.facebook.com/LakesideVA", "http://www.facebook.com/metropointeapts"]
      }
      assert_equal(expected, result_hash)
    end
  end

  describe ".deep_locate_all_by_key(data, key)" do
    it "returns all the values as an array" do
      result_array = MitsParser.deep_locate_all_by_key(@property_data, "OpenTime")
      assert result_array.include?({
        "OpenTime"  => "12:00 PM",
        "CloseTime" => "5:00 PM",
        "Day"       => "Sunday"
      })
    end
  end

  describe ".deep_find_all_by_key(data, key)" do
    # it "returns all the values as an array" do
    #   result_hash = MitsParser.deep_find_all_by_key(@property_data, "FacebookURL")
    #   expected = ["http://www.facebook.com/LakesideVA", "http://www.facebook.com/metropointeapts"]
    #   assert_equal(expected, result_hash)
    # end

    it "returns all the values that were found as an array" do
      result_hash = MitsParser.deep_find_all_by_key(@property_data, "Address")
      expected = [
        {
          "Address1"=>"6221 Summer Pond Drive",
          "City"=>"Centreville",
          "State"=>"VA",
          "PostalCode"=>"20121",
          "CountyName"=>"Fairfax",
          "Lead2LeaseEmail"=>"lakesideboz@lead2lease.com"
        },
        {
          "Address1"=>"11175 Georgia Avenue",
          "City"=>"Wheaton",
          "State"=>"MD",
          "PostalCode"=>"20902",
          "CountyName"=>"Montgomery",
          "Lead2LeaseEmail"=>"bmcmetropointe@lead2lease.com"
        }]
      assert_equal(expected, result_hash)
    end
  end


  # ===
  # ===


  describe ".find_address" do
    subject { MitsParser.find_address(@property_data) }

    it "returns an array of address info" do
      assert subject.is_a?(Array)
      assert /city/i =~ subject.to_s
      assert /state/i =~ subject.to_s
    end
  end


  # ===
  # ===


  describe "Property" do
    subject { MitsParser::Property.new(@property_data) }

    it "is a MitsParser::Property" do
      assert subject.is_a?(MitsParser::Property)
    end

    it "#address" do
      assert subject.respond_to?(:address)
    end
  end
end
