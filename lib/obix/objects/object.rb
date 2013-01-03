module OBIX
  module Objects

    # Objects are the root abstraction in oBIX.
    class Object
      extend Accessible

      attribute :name, type: Types::String
      attribute :href, type: Types::String
      attribute :is, type: Types::String
      attribute :null, type: Types::Boolean
      attribute :icon, type: Types::String
      attribute :display_name, type: Types::String
      attribute :display, type: Types::String
      attribute :writable, type: Types::Boolean
      attribute :status, type: Types::String

      def initialize attributes, objects
        @attributes = attributes.merge objects

        objects.each do |key, value|
          self.class.send :attribute, key
        end
      end

      def to_s
        "#<OBIX::Objects::Object #{@attributes}>"
      end

      class << self

        # Initialize an object with the given string.
        #
        # object - A Nokogiri::XML::Node describing an object.
        #
        # Returns an Object instance.
        def parse object
          attributes = {}
          objects    = {}

          object.attributes.each do |name, attribute|
            attributes.store name, attribute.value
          end

          object.children.each do |child|
            name   = child["name"].underscore
            object = OBIX.parse_element child

            objects.store name, object
          end

          new attributes, objects
        end

      end

    end

  end
end