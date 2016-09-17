require "active_support/all"
require "awesome_print"

# Adopted from Rails
# http://apidock.com/rails/Hash/from_xml/class
def from_xml(xml, disallowed_types = nil)
  ActiveSupport::XMLConverter.new(xml, disallowed_types).to_h
end

# Check currently working directory.
puts "Dir.pwd:  #{Dir.pwd}"

# absolute path to the source XML file.
filename = "#{Dir.pwd}/test/fixtures/files/ash_a.xml"
puts "filename: #{filename}"

# Read that file.
xml = File.read(filename)

# Convert xml to hash using ActiveSupport::XMLConverter
hash = Hash.from_xml(xml)

ap hash
