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

    # Store the passed-in mits data.
    @data = mits_data

    # Create a MitsQuery representation of all the properties.
    @mits_query = MitsQuery::Properties.from(@data)
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

      # Format things.
      address      = MitsFormatter::Address.format!(mits_query.address)
      amenities    = MitsFormatter::Amenities.format!(mits_query.amenities)
      email        = MitsFormatter::Email.format!(mits_query.email)
      description  = MitsFormatter::FeedUid.format!(mits_query.description)
      feed_uid     = MitsFormatter::FeedUid.format!(mits_query.feed_uid)
      floorplans   = MitsFormatter::Floorplans.format!(mits_query.floorplans)
      information  = MitsFormatter::Information.format!(mits_query.information)
      name         = MitsFormatter::Name.format!(mits_query.name)
      latitude     = MitsFormatter::Latitude.format!(mits_query.latitude)
      lease_length = MitsFormatter::LeaseLength.format!(mits_query.lease_length)
      longitude    = MitsFormatter::Longitude.format!(mits_query.longitude)
      office_hours = MitsFormatter::OfficeHours.format!(mits_query.office_hours)
      parking      = MitsFormatter::Parking.format!(mits_query.parking)
      phones       = MitsFormatter::Phones.format!(mits_query.phones)
      photos       = MitsFormatter::Photos.format!(mits_query.photos)
      pet_policy   = MitsFormatter::PetPolicy.format!(mits_query.pet_policy)
      promotions   = MitsFormatter::Promotions.format!(mits_query.promotions)
      url          = MitsFormatter::Url.format!(mits_query.url)
      utilities    = MitsFormatter::Utilities.format!(mits_query.utilities)


      # Return a hash in our desired format.
      # We can cofigure the formats in the MitsFormatter class.
      {
        :raw_hash     => @data,

        :floorplans   => floorplans,

        # Address fields
        :address      => address["Address"],
        :city         => address["City"],
        :county       => address["County"],
        :state        => address["State"],
        :zip          => address["Zip"],
        :po_box       => address["PO_Box"],
        :country      => address["Country"],

        # Lease length
        :lease_length_min => lease_length[:min],
        :lease_length_max => lease_length[:max],


        :amenities    => amenities,
        :email        => email,
        :description  => description,
        :feed_uid     => feed_uid,
        :name         => name,
        :latitude     => latitude,
        :longitude    => longitude,
        :office_hours => office_hours,
        :parking      => parking,
        :phones       => phones,
        :photos       => photos,
        :pet_policy   => pet_policy,
        :promotions   => promotions,
        :url          => url,
        :utilities    => utilities,
      }
    end
end

=begin
----------------------------
# All the top level keys
----------------------------
[
    [ 0] :raw_hash,
    [ 1] :floorplans,
    [ 2] :unique_feed_identifiers,
    [ 3] :longitude,
    [ 4] :latitude,
    [ 5] :names,
    [ 6] :urls,
    [ 7] :emails,
    [ 8] :phones,
    [ 9] :descriptions,
    [10] :information,
    [11] :office_hours,
    [12] :photo_urls,
    [13] :pet_policy,
    [14] :promotional_info,
    [15] :amenities,
    [16] :utilities,
    [17] :parking,
    [18] :address,
    [19] :city,
    [20] :county,
    [21] :zip,
    [22] :po_box,
    [23] :country,
    [24] :state,
    [25] :lease_length_min,
    [26] :lease_length_max
]
=end
