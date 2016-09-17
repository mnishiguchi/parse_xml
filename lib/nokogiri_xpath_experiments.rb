require 'nokogiri'
require "awesome_print"

# Check currently working directory.
puts "Dir.pwd:  #{Dir.pwd}"

# absolute path to the source XML file.
filename = "#{Dir.pwd}/test/fixtures/files/ash_a.xml"
puts "filename: #{filename}"

# Read that file.
xml = File.read(filename)

# Parse xml using Nokogiri.
doc = Nokogiri.XML(xml)

# Get XPATHs.
# http://stackoverflow.com/a/15692699/3837223
xpaths = []
doc.xpath('//*[child::* and not(child::*/*)]').each { |node| xpaths << node.path }

ap xpaths
