require_relative "./mits_formatter.rb"

=begin
A MitsParser object restructures a given piece of mits data into our
predetermined schema with assistance of the classes MitsQuery and  MitsFormatter.
---
Usage:
  formatted_mits = MitsParser.new(mits_data).parse
  #==> Formatted array of hashes.
=end

class MitsParser

  def initialize(mits_data)
    unless mits_data.is_a?(Array) || mits_data.is_a?(Hash)
      raise "data must be array or hash"
    end

    # Create a MitsQuery representation of all the properties.
    @mits_query = MitsQuery::Properties.from(mits_data)
  end

  def parse
    @parsed ||= @mits_query.map { |property| format_property!(property) }
  end

  private

    # Takes a MitsQuery::Property object that represents a SINGLE property.
    def format_property!(mits_query)
      unless mits_query.is_a?(MitsQuery::Property)
        raise ArgumentError.new("mits_query must be a MitsQuery::Property")
      end

      # Field that will not be part of the hash.
      MitsFormatter::Information.format!(mits_query.information)

      # Return a hash in our desired format.
      # We can cofigure the formats in the MitsFormatter class.
      return {
        :address      => MitsFormatter::Address.format!(mits_query.address),
        :amenities    => MitsFormatter::Amenities.format!(mits_query.amenities),
        :email        => MitsFormatter::Email.format!(mits_query.email),
        :description  => MitsFormatter::FeedUid.format!(mits_query.description),
        :feed_uid     => MitsFormatter::FeedUid.format!(mits_query.feed_uid),
        :floorplans   => MitsFormatter::Floorplans.format!(mits_query.floorplans),
        :name         => MitsFormatter::Name.format!(mits_query.name),
        :latitude     => MitsFormatter::Latitude.format!(mits_query.latitude),
        :lease_length => MitsFormatter::LeaseLength.format!(mits_query.lease_length),
        :longitude    => MitsFormatter::Longitude.format!(mits_query.longitude),
        :office_hours => MitsFormatter::OfficeHours.format!(mits_query.office_hours),
        :parking      => MitsFormatter::Parking.format!(mits_query.parking),
        :phones       => MitsFormatter::Phones.format!(mits_query.phones),
        :photos       => MitsFormatter::Photos.format!(mits_query.photos),
        :pet_policy   => MitsFormatter::PetPolicy.format!(mits_query.pet_policy),
        :promotions   => MitsFormatter::Promotions.format!(mits_query.promotions),
        :url          => MitsFormatter::Url.format!(mits_query.url),
        :utilities    => MitsFormatter::Utilities.format!(mits_query.utilities)
      }
    end
end
