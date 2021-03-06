require 'nokogiri'

module NokoParser
  
  class NokoParserError < StandardError; end

  def self.version
    "0.1.0"
  end
  
end

## Stolen from merb-core
class Object
  def full_const_get(name)
    list = name.split("::")
    list.shift if list.first.empty?
    obj = self
    list.each do |x| 
      # This is required because const_get tries to look for constants in the 
      # ancestor chain, but we only want constants that are HERE
      obj = obj.const_defined?(x) ? obj.const_get(x) : obj.const_missing(x)
    end
    obj
  end
end

require 'noko_parser/parser'
require 'noko_parser/properties'
