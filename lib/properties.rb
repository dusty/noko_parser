module NokoParser
  
  module Properties
    
    ##
    # Text property is used to find the innerhtml of an element
    class TextProperty
      attr_reader :name, :xpath
  
      def initialize(name,xpath)
        @name = name.to_s
        @xpath = xpath.to_s
      end
  
    end

    ##
    # Attribute property is used to find the value of an attribute of an
    # element
    class AttributeProperty
      attr_reader :name, :xpath, :attribute
  
      def initialize(name,xpath,attribute)
        @name = name.to_s.downcase
        @xpath = xpath.to_s
        @attribute = attribute.to_s
      end
  
    end

    ##
    # Embedded property is used to find the value of sub-elements inside the
    # element
    #
    # If single is present, only the first element will be returned
    # otherwise an array is returned
    class EmbeddedProperty
      attr_reader :name, :xpath, :class_name, :single
      
      def initialize(name,xpath,class_name,single)
        @name = name.to_s.downcase
        @xpath = xpath.to_s
        @class_name = class_name.to_s
        @single = single || false
      end
      
    end
    
    def self.included(base)
      base.instance_variable_set(:@_text_properties,[])
      base.instance_variable_set(:@_attribute_properties,[])
      base.instance_variable_set(:@_embedded_properties,[])
      base.send(:extend, ClassMethods)
      base.send(:include, InstanceMethods)
    end
  
    module ClassMethods
    
      ##
      # Parse an xml string
      #
      # @return [Array<Object>] an array of objects
      # @see NokoParser::Parser
      def parse(xml)
        parser = NokoParser::Parser.new(self,xml)
        parser.run
      end
      
      ##
      # Parse an xml file
      #
      # @return [Array<Object>] an array of objects
      # @see NokoParser::Parser
      def parse_file(file)
        parse(open(file))
      end
      
      ##
      # Make sure this class is a noko_parser compatible class
      def _is_noko_parser?
        true
      end
      
      ##
      # Returns the TextProperties defined on the class
      #
      # @return [Array<TextProperty>]
      def _text_properties
        @_text_properties
      end
    
      ##
      # Returns the AttributeProperties defined in the class
      #
      # @return [Array<AttributeProperty]
      def _attribute_properties
        @_attribute_properties
      end
      
      ##
      # Returns the EmbeddedProperties defined on the class
      #
      # @return [Array<EmbedProperty>]
      def _embedded_properties
        @_embedded_properties
      end
      
      ##
      # Returns the xpath required to find the nodes
      def _nodes_xpath
        @_nodes_xpath || (raise NokoParserError, 'nodes :xpath => "" is required')
      end
    
      ##
      # Set the xpath for finding the nodes.
      #
      # examples:
      # nodes '//monkeys'
      # nodes '//animals/monkeys/friendly'
      def nodes(opts={})
        unless opts[:xpath]
          raise NokoParserError, ":xpath required for nodes definition"
        end
        @_nodes_xpath = opts[:xpath].to_s
      end
    
      ##
      # Sets a property on the object.  If :attribute is defined it will
      # set an AttributeProperty.  Otherwise, it will set a TextProperty
      # :xpath => 'somexpathstring' is required.  The xpath should be the
      # query required to find this element inside the node.
      #
      # examples
      # property :name, :xpath => 'MyName[@type="real_name"]'
      # property :eye_color, :xpath => 'eyes', :attribute => 'color'
      def property(name,opts={})
        unless opts[:xpath]
          raise NokoParserError, ":xpath required for #{name}"
        end
        if opts[:attribute]
          _add_attribute_property(name,opts[:xpath],opts[:attribute])
        else
          _add_text_property(name,opts[:xpath])
        end
      end
      
      ##
      # Sets an embedded property on the option.
      #
      # examples:
      # embed :names, :xpath => 'names', :class => Name
      def embed(name,opts={})
        unless opts[:class]
          raise NokoParserError, ":xpath and :class required for #{name}"
        end
        _add_embedded_property(name,opts[:xpath],opts[:class],opts[:single])
      end
    
      protected
      ##
      # Adds to the class variable @text_properties in addition to
      # creating an accessor for this property
      def _add_text_property(name,xpath)
        @_text_properties << TextProperty.new(name,xpath)
        send(:attr_accessor, name)
      end
    
      ##
      # Adds to the class variable @attribute_properties in addition to
      # creating an accessor for this property
      def _add_attribute_property(name,xpath,attribute)
        @_attribute_properties << AttributeProperty.new(
          name,xpath,attribute
        )
        send(:attr_accessor, name)
      end
      
      ##
      # Adds to the class variable @embedded_properties in addition to
      # creating a reader for this property
      def _add_embedded_property(name,xpath,class_name,single)
        @_embedded_properties << EmbeddedProperty.new(
          name,xpath,class_name,single
        )
        send(:attr_accessor, name)
      end
    
    end # ClassMethods
  
    module InstanceMethods
    
      def method_missing(*args)
        nil
      end
    
    end
    
  end
  
end # NokoParser