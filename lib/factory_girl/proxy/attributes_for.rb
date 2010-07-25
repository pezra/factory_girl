module FactoryGirl
  class Proxy #:nodoc:
    class AttributesFor < Proxy #:nodoc:
      def initialize(klass, production_parameters)
        super
        @hash = {}
      end

      def get(attribute)
        @hash[attribute]
      end

      def set(attribute, value)
        @hash[attribute] = value
      end

      def result
        @hash
      end
    end
  end
end
