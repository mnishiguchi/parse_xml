require "awesome_print"
require 'nokogiri'


# Read an xml file from the specified path and returns the parsed xml document.
def load_xml(file_path)
  # Read the source XML file.
  puts "file_path: #{file_path}"
  raw_xml = File.read(file_path)

  # Parse raw_xml using Nokogiri.
  xml_document = Nokogiri.XML(raw_xml)
end


# Obtains XPATHs.
# http://stackoverflow.com/a/15692699/3837223
def uniq_xpaths(xml_document)
  xpaths = []
  xml_document.xpath('//*[child::* and not(child::*/*)]').each { |node| xpaths << node.path }
  xpaths.each { |path| path.gsub!(/\[\d*\]/, "[]") }.uniq!
end


# ---
# Read a single XML file
# ---


file_path    = "#{Dir.pwd}/test/fixtures/files/feed_f.xml"
xml_document = load_xml(file_path)
# ap uniq_xpaths(xml_document)

ap xml_document.at_xpath("/PhysicalProperty/Property/Floorplan")
ap xml_document.at_xpath("/PhysicalProperty/Property/File")


# ---
# Read XML files
# ---


# pattern   = File.join(Dir.pwd, "test", "fixtures", "files", "feed_*.xml")
# filenames = Dir.glob(pattern)
# filenames
#
# xpaths = []
#
# filenames.each do |file|
#   xml_document = load_xml(file)
#   xpaths << uniq_xpaths(xml_document)
# end
