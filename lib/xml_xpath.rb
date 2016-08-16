require 'nokogiri'
require "awesome_print"

# Check current working directory.
puts Dir.pwd

# absolute path to the source XML file.
filename = "/Users/mnishiguchi/projects/parse_xml/db/feeds/ash_a.xml"
# filename = "/Users/masa/projects/ruby/parse_xml/db/feeds/ash_a.xml"
# p filename

# Read that file.
xml = File.read(filename)

# Parse xml using Nokogiri.
doc = Nokogiri.XML(xml)

# Get XPATHs.
# http://stackoverflow.com/a/15692699/3837223
xpaths = []
doc.xpath('//*[child::* and not(child::*/*)]').each { |node| xpaths << node.path }

ap xpaths
