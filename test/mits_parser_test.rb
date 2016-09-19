require_relative "../lib/mits_parser/mits_parser.rb"

describe MitsParser do

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


  describe "Property#address" do

    let(:properties) { MitsParser.new(@property_data).find_all_properties }
    let(:address) { MitsParser::Property.new(properties.first).address }

    it "returns an array of address info" do
      assert /city/i  =~ address.to_s
      assert /state/i =~ address.to_s
    end
  end

  describe "Property#amenitiees" do
    # TODO

    # let(:properties) { MitsParser.new(@property_data).find_all_properties }
    # let(:address) { MitsParser::Property.new(properties.first).address }
    #
    # it "returns an array of address info" do
    #   assert /city/i  =~ address.to_s
    #   assert /state/i =~ address.to_s
    # end
  end



end
