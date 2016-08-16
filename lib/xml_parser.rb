require "rails/all"
require "oga"
require "awesome_print"

# Check current working directory.
puts Dir.pwd

# Filename in absolute path.
filename = "/Users/masa/projects/ruby/parse_xml/db/feeds/ash_b.xml"
p filename

# Read that tile.
xml = File.read(filename)

# Parse xml
doc = Oga.parse_xml(xml)

# Inspect the result
# p doc
p doc.xpath("//Property/Identification").map{ |t| t.text }
