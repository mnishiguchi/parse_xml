require_relative "./mits_formatter.rb"

=begin
MitsProperty represents our formated property data.
It is a wrapper of all the formatted attributes, which can be passed in to
the corresponding ActiveRecord model.
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

    # ap @property.amenities

    @address      = MitsFormatter::Address.new(@property.address)
    @amenities    = MitsFormatter::Amenities.new(@property.amenities)
    # @email       = MitsFormatter::Email.new(@property.emails)
    # @feed_uid     = MitsFormatter::FeedUid.new(@property.feed_uid)
    # @floorplans   = MitsFormatter::Floorplans.new(@property.floorplans)
    # @information  = MitsFormatter::Information.new(@property.information)
    # @names        = MitsFormatter::Names.new(@property.names)
    # @latitude     = MitsFormatter::Latitude.new(@property.latitude)
    # @lease_length = MitsFormatter::LeaseLength.new(@property.lease_length)
    # @longitude    = MitsFormatter::Longitude.new(@property.longitude)
    # @office_hours = MitsFormatter::OfficeHours.new(@property.office_hours)
    # @parking      = MitsFormatter::Parking.new(@property.parking)
    # @phones       = MitsFormatter::Phones.new(@property.phones)
    # @photos       = MitsFormatter::Photos.new(@property.photos)
    # @pet_policy   = MitsFormatter::PetPolicy.new(@property.pet_policy)
    # @promotions   = MitsFormatter::Promotions.new(@property.promotions)
    # @urls         = MitsFormatter::Urls.new(@property.urls)
    @utilities    = MitsFormatter::Utilities.new(@property.utilities)
    freeze
  end
end
