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
