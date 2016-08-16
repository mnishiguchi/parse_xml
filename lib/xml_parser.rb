require "oga"
require "awesome_print"

# Check current working directory.
puts Dir.pwd

# absolute path to the source XML file.
filename = "/Users/mnishiguchi/projects/parse_xml/db/feeds/ash_a.xml"
# filename = "/Users/masa/projects/ruby/parse_xml/db/feeds/ash_a.xml"
p filename

# Read that file.
xml = File.read(filename)

# Parse xml using Oga.
doc = Oga.parse_xml(xml)

# Inspect <Managemenet />
doc.xpath("//PhysicalProperty/Management").each do |item|
  # Read the attribute 'id' in the element.
  ap item.get('id')

  # Read the child element "<Name/>"
  ap item.at_xpath('Name').text
end

# Inspect <Property />
doc.xpath("//PhysicalProperty/Property").each do |item|
  # Read the attribute 'managementID' in the element.
  ap item.get('managementID')

  ap item.at_xpath('Identification').get('Type')
  ap item.at_xpath('Identification').get('RentalType')

  ap item.at_xpath('Identification/PrimaryID').text
  ap item.at_xpath('Identification/MarketingName').text
  ap item.at_xpath('Identification/OwnerLegalName').text

  ap item.at_xpath('Identification/Address/Address1').text
  ap item.at_xpath('Identification/Address/City').text
  ap item.at_xpath('Identification/Address/State').text
  ap item.at_xpath('Identification/Address/Zip').text

  ap item.at_xpath('Identification/Latitude').text
  ap item.at_xpath('Identification/Longitude').text

  ap item.at_xpath('Identification/Phone/Number').text
  ap item.at_xpath('Identification/Fax/Number').text
  ap item.at_xpath('Identification/Email').text

  ap item.at_xpath('Information/UnitCount').text
end
