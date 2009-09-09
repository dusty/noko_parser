module NokoParser
  
  class Parser
    
    ##
    # Initialize the parser by passing in a class that has included
    # NokoParser::Properties
    #
    # @raises [NokoParserError] unless class included NokoParser::Properties
    def initialize(klass, xml)
      unless klass.respond_to?('_is_noko_parser?')
        raise NokoParserError, 'Class must include NokoParser::Properties'
      end
      @object = klass
      @xml = Nokogiri::XML(xml)
      @nodes = []
      @text_properties = klass._text_properties
      @attribute_properties = klass._attribute_properties
      @embedded_properties = klass._embedded_properties
    end
    
    ##
    # Runs the parser on the class.  First finds the nodes that match
    # and then parses the text and attribute properties on it
    #
    # return [Array<Object>] an array of objects
    def run
      @xml.xpath(@object._nodes_xpath).each do |node|
        object = @object.new
        parse_text_properties(node,object)
        parse_attribute_properties(node,object)
        parse_embedded_properties(node,object)
        @nodes << object
      end
      @nodes
    end
    
    private
    
    ##
    # Loop through the text properties of the class and use the defined
    # xpath query to find the match.  If found add to the object using
    # the setter.
    def parse_text_properties(node,object)
      @text_properties.each do |property|
        if match = node.xpath(property.xpath).first
          unless match.inner_text.empty?
            object.send("#{property.name}=",match.inner_text)
          end
        end
      end
    end
    
    ##
    # Loop through the attribute properties of the class and use the defined
    # xpath query to find the match.  If found add to the object using
    # the setter.
    def parse_attribute_properties(node,object)
      @attribute_properties.each do |property|
        if match = node.xpath(property.xpath).first
          object.send("#{property.name}=",match.attribute(property.attribute))
        end
      end
    end
    
    ##
    # Loop through the embedded properties of the class and use the defined
    # xpath query to find the match.  If found add to the object using the
    # setter.
    def parse_embedded_properties(node,object)
      @embedded_properties.each do |property|
        unless parser = Object.full_const_get(property.class_name) rescue nil
          raise NokoParserError, 
          "Class #{property.class_name} not found for embed :#{property.name}"
        end
        if match = node.xpath(property.xpath).first
          result = parser.parse(match.to_xml)
          result = result.first if property.single
          object.send("#{property.name}=", result)
        end
      end
    end
    
  end
  
end