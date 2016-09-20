require_relative "./mits_field.rb"

=begin
MitsParser is an organizer of the process of parsing Mits feed into our Mits schema.

Usage:
  parser = MitsParser.new(mits_data).parse
  #==> Formatted array of hashes.
=end

class MitsParser

  def initialize(mits_data)
    unless mits_data.is_a?(Array) || mits_data.is_a?(Hash)
      raise "data must be array or hash"
    end

    # MitsQuery representation of the properties.
    @properties = MitsQuery::Properties.from(mits_data).map do |property|
      MitsQuery::Property.new(property)
    end
  end

  def parse
    @parsed ||= @properties.map { |property| format_property!(property) }
  end

  # property_data - a MitsQuery::Property object that represents a SINGLE property.
  def format_property!(property_data)
    unless property_data.is_a?(MitsQuery::Property)
      raise ArgumentError.new("property_data must be a MitsQuery::Property")
    end

    # Field that will not be part of the hash.
    MitsField::Information.from(property_data.information)

    # Return a hash in our desired format.
    return {
      :address      => MitsField::Address.from(property_data.address),
      :amenities    => MitsField::Amenities.from(property_data.amenities),
      :email        => MitsField::Email.from(property_data.email),
      :description  => MitsField::FeedUid.from(property_data.description),
      :feed_uid     => MitsField::FeedUid.from(property_data.feed_uid),
      :floorplans   => MitsField::Floorplans.from(property_data.floorplans),
      :name         => MitsField::Name.from(property_data.name),
      :latitude     => MitsField::Latitude.from(property_data.latitude),
      :lease_length => MitsField::LeaseLength.from(property_data.lease_length),
      :longitude    => MitsField::Longitude.from(property_data.longitude),
      :office_hours => MitsField::OfficeHours.from(property_data.office_hours),
      :parking      => MitsField::Parking.from(property_data.parking),
      :phones       => MitsField::Phones.from(property_data.phones),
      :photos       => MitsField::Photos.from(property_data.photos),
      :pet_policy   => MitsField::PetPolicy.from(property_data.pet_policy),
      :promotions   => MitsField::Promotions.from(property_data.promotions),
      :url          => MitsField::Url.from(property_data.url),
      :utilities    => MitsField::Utilities.from(property_data.utilities)
    }
  end
end
