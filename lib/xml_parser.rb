require "rails/all"
require "oga"
require "awesome_print"

# Parse the specified XML file.
def xml_parser(filename)
  # Read that file.
  xml = File.read(filename)

  # Parse xml using Oga.
  doc = Oga.parse_xml(xml)
end

# Check current working directory.
puts Dir.pwd

# absolute path to the source XML file.
filename = "/Users/mnishiguchi/projects/parse_xml/db/feeds/ash_a.xml"
# filename = "/Users/masa/projects/ruby/parse_xml/db/feeds/ash_b.xml"
p filename

# Parse the XML.
doc = xml_parser(filename)

# Inspect the parsed document.
# p doc
# ap doc.xpath("//PhysicalProperty/Management").map{ |t| t.text }
# ap doc.xpath("//PhysicalProperty/Property").map{ |t| t.text }
# doc.xpath("//PhysicalProperty/Management").each do |item|
#   puts item.get('name')
# end
doc.xpath("//PhysicalProperty/Management").each do |item|
  # Read the attribute 'id' in the element.
  ap item.get('id')

  # Read the child element "<Name/>"
  ap item.at_xpath('Name').text
end
