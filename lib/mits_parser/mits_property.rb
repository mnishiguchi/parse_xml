require_relative "./mits_field.rb"

=begin
MitsProperty represents our formated property data.
It can be converted into JSON or XML.
=end
class MitsProperty
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

  # property_data - a MitsParser::Property object that represents a SINGLE property.
  def initialize(property_data)
    # Ensure args are of proper data types.
    unless property_data.is_a?(MitsParser::Property)
      raise ArgumentError.new("property_data must be a MitsParser::Property")
    end

    @property = property_data

    @address          = MitsField::Address.new(@property.address)
    # @amenities        = MitsField::Amenities.new(@parser.todo)
    # @descriptions     = MitsField::Descriptions.new(@parser.todo)
    # @emails           = MitsField::Emails.new(@parser.todo)
    # @feed_uid         = MitsField::FeedUid.new(@parser.todo)
    # @floorplans       = MitsField::Floorplans.new(@parser.todo)
    # @information      = MitsField::Information.new(@parser.todo)
    # @names            = MitsField::Names.new(@parser.todo)
    # @latitude         = MitsField::Latitude.new(@parser.todo)
    # @lease_length     = MitsField::LeaseLength.new(@parser.todo)
    # @longitude        = MitsField::Longitude.new(@parser.todo)
    # @office_hours     = MitsField::OfficeHours.new(@parser.todo)
    # @parking          = MitsField::Parking.new(@parser.todo)
    # @phones           = MitsField::Phones.new(@parser.todo)
    # @photos           = MitsField::Photos.new(@parser.todo)
    # @pet_policy       = MitsField::PetPolicy.new(@parser.todo)
    # @promotions       = MitsField::Promotions.new(@parser.todo)
    # @urls             = MitsField::Urls.new(@parser.todo)
    # @utilities        = MitsField::Utilities.new(@parser.todo)
    freeze
  end
end
