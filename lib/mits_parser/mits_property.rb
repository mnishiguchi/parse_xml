require_relative "./mits_formatter.rb"

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

    @address          = MitsFormatter::Address.new(@property.address)
    # @amenities        = MitsFormatter::Amenities.new(@parser.todo)
    # @descriptions     = MitsFormatter::Descriptions.new(@parser.todo)
    # @emails           = MitsFormatter::Emails.new(@parser.todo)
    # @feed_uid         = MitsFormatter::FeedUid.new(@parser.todo)
    # @floorplans       = MitsFormatter::Floorplans.new(@parser.todo)
    # @information      = MitsFormatter::Information.new(@parser.todo)
    # @names            = MitsFormatter::Names.new(@parser.todo)
    # @latitude         = MitsFormatter::Latitude.new(@parser.todo)
    # @lease_length     = MitsFormatter::LeaseLength.new(@parser.todo)
    # @longitude        = MitsFormatter::Longitude.new(@parser.todo)
    # @office_hours     = MitsFormatter::OfficeHours.new(@parser.todo)
    # @parking          = MitsFormatter::Parking.new(@parser.todo)
    # @phones           = MitsFormatter::Phones.new(@parser.todo)
    # @photos           = MitsFormatter::Photos.new(@parser.todo)
    # @pet_policy       = MitsFormatter::PetPolicy.new(@parser.todo)
    # @promotions       = MitsFormatter::Promotions.new(@parser.todo)
    # @urls             = MitsFormatter::Urls.new(@parser.todo)
    # @utilities        = MitsFormatter::Utilities.new(@parser.todo)
    freeze
  end
end
