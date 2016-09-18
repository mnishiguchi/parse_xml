require_relative "../lib/mits_parser/mits_property.rb"

describe MitsProperty do

  let(:mits_parser_property) do
    # The absolute path to the source XML file.
    path = File.join(FILE_DIR, "boz.xml")

    # Read an example xml data.
    xml = File.read(path)

    # Create a MitsParser::Property that represents a single property.
    data       = Hash.from_xml(xml)["PhysicalProperty"]
    parser     = MitsParser.new(data)
    property   = MitsParser::Property.new(parser.find_all_properties.first)
  end

  it "is a MitsParser::Property" do
    assert MitsProperty.new(mits_parser_property).is_a?(MitsProperty)
  end

  describe "when MitsParser::Property object is passed in" do
    subject { MitsProperty.new({ name: "Example User", email: "user@example.com" }) }

    it "raises an exception" do
      assert_raises(Exception)
    end
  end


  describe "#address" do
    subject { MitsProperty.new(mits_parser_property).address }

    it "has correct attributes" do
      subject.respond_to?(:address)
      subject.respond_to?(:city)
      subject.respond_to?(:county)
      subject.respond_to?(:state)
      subject.respond_to?(:zip)
      subject.respond_to?(:po_box)
    end
  end


  # TODO: other fields...

end
