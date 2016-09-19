require_relative "../lib/mits_parser/mits_property.rb"

describe MitsProperty do

  let(:ash_mits_parser_property) do
    path = File.join(FILE_DIR, "ash.xml")
    xml  = File.read(path)

    # Create a MitsParser::Property that represents a single property.
    data       = Hash.from_xml(xml)["PhysicalProperty"]
    parser     = MitsParser.new(data)
    property   = MitsParser::Property.new(parser.find_all_properties.first)
  end

  let(:boz_mits_parser_property) do
    path = File.join(FILE_DIR, "boz.xml")
    xml  = File.read(path)

    # Create a MitsParser::Property that represents a single property.
    data       = Hash.from_xml(xml)["PhysicalProperty"]
    parser     = MitsParser.new(data)
    property   = MitsParser::Property.new(parser.find_all_properties.first)
  end

  it "is a MitsParser::Property" do
    assert MitsProperty.new(ash_mits_parser_property).is_a?(MitsProperty)
    assert MitsProperty.new(boz_mits_parser_property).is_a?(MitsProperty)
  end

  describe "when MitsParser::Property object is passed in" do
    subject { MitsProperty.new({ name: "Example User", email: "user@example.com" }) }

    it "raises an exception" do
      assert_raises(Exception)
    end
  end


  describe "#address" do
    let(:address) { MitsProperty.new(boz_mits_parser_property).address }

    it "has correct data hash" do
      # ap address.data
      assert address.data.is_a?(Hash)
      assert address.data["State"] == "VA"
      assert address.data["Zip"] == "20121"
    end
  end

  describe "#amenities" do
    let(:amenities) { MitsProperty.new(ash_mits_parser_property).amenities }

    it "has correct data hash" do

      ap amenities.data
      assert amenities.data.is_a?(Hash)
      assert amenities.data["Community"].present?
      assert amenities.data["Floorplan"].present?
    end
  end

  # TODO




  # TODO: other fields...

end
