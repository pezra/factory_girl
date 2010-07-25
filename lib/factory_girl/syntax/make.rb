module FactoryGirl
  module Syntax

    # Extends ActiveRecord::Base to provide a make class method, which is a
    # shortcut for Factory.create.
    #
    # Usage:
    #
    #   require 'factory_girl/syntax/make'
    #
    #   Factory.define :user do |factory|
    #     factory.name 'Billy Bob'
    #     factory.email 'billy@bob.example.com'
    #   end
    #
    #   User.make(:name => 'Johnny')
    #
    # This syntax was derived from Pete Yandell's machinist.
    module Make
      module ActiveRecord #:nodoc:

        def self.included(base) # :nodoc:
          base.extend ClassMethods
        end

        module ClassMethods #:nodoc:

          def make(overrides = {})
            factory_name = name.underscore
            FactoryGirl.factory_by_name(factory_name).run(Proxy::Create, factory_name, overrides)
          end

        end

      end
    end
  end
end

ActiveRecord::Base.send(:include, FactoryGirl::Syntax::Make::ActiveRecord)
