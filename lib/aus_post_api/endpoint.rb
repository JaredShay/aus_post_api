require_relative "./endpoint/attributes"

# The Endpoint class is an abstract class that sets attributes and handles the
# execution of API endoint calls.
#
# It requires two instance methods to be defined.
#    * `uri` - returns a valid uri string that represents the full api path
#    * `headers` - returns a hash of key value pairs for the request
#
# The attributes module adds class level methods for specifying the attributes
# of the API call.
#    * `required_attributes`
#    * `optional_attributes`
module AusPostAPI
  class Endpoint
    include AusPostAPI::Endpoint::Attributes

    def initialize(attributes, config, uri_handler = AusPostAPI::UriHandler)
      @config      = config
      @attributes  = attributes
      @uri_handler = uri_handler

      set_attributes
    end

    def execute
      @uri_handler.call(uri, headers)
    end

    private

    def uri
      raise ImplementationError.new("uri")
    end

    def headers
      raise ImplementationError.new("headers")
    end

    def set_attributes
      required_param = -> (attr) { raise RequiredArgumentError.new(attr) }

      required_attributes.each do |attr|
        self.send("#{attr}=", @attributes.fetch(attr, &required_param))
      end

      optional_attributes.each do |attr|
        if @attributes.has_key?(attr)
          self.send("#{attr}=", @attributes.fetch(attr))
        end
      end
    end

    class RequiredArgumentError < StandardError
      def initialize(attr)
        super("#{attr} is a required argument")
      end
    end

    class ImplementationError < StandardError
      def initialize(method)
        super("No #{method} implemented")
      end
    end
  end
end
