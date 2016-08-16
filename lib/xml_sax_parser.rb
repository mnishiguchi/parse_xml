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


class SaxHandler
  def on_element(namespace, name, attrs = {})
    puts name
  end
end

handler = SaxHandler.new
parser  = Oga::XML::SaxParser.new(handler, xml)
doc = parser.parse

ap doc
