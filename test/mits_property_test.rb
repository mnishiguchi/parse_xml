require_relative "../lib/mits_parser/mits_property.rb"

=begin
TODO
=end
describe MitsProperty do

  before do
    # The absolute path to the source XML file.
    path = File.join(FILE_DIR, "boz.xml")

    # Read an example xml data.
    xml = File.read(path)

    # Create a MitsParser::Property that represents a single property.
    data       = Hash.from_xml(xml)["PhysicalProperty"]
    parser     = MitsParser.new(data)
    @property  = MitsParser::Property.new(parser.find_all_properties.first)
  end

  it "has address" do
    property = MitsProperty.new(@property)
    assert property.respond_to?(:address)
  end

  describe "only accepts MitsParser::Property object" do
    subject { MitsProperty.new({ name: "Example User", email: "user@example.com" }) }

    it "raises an exception" do
      assert_raises(Exception)
    end
  end



end
