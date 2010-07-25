module FactoryGirl
  class Attribute #:nodoc:

    class Dynamic < Attribute  #:nodoc:
      def initialize(name, block)
        super(name)
        @block = block
      end

      def add_to(proxy)
        value = case @block.arity
                when 0
                  @block.call
                when 1
                  @block.call(proxy)
                else
                  @block.call(proxy, *proxy.production_parameters)
                end

        if FactoryGirl::Sequence === value
          raise SequenceAbuseError
        end
        proxy.set(name, value)
      end
    end

  end
end
