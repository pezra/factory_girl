require 'spec_helper'

describe FactoryGirl::Attribute::Dynamic do
  before do
    @name  = :first_name
    @block = lambda { 'value' }
    @attr  = FactoryGirl::Attribute::Dynamic.new(@name, @block)
  end

  it "should have a name" do
    @attr.name.should == @name
  end

  it "should call the block to set a value" do
    @proxy = stub!.set
    stub(@proxy).production_parameters {[]}
    stub(@proxy).set
    @attr.add_to(@proxy)
    @proxy.should have_received.set(@name, 'value')
  end

  it "should yield the proxy to the block when adding its value to a proxy" do
    @block = lambda {|a| a }
    @attr  = FactoryGirl::Attribute::Dynamic.new(:user, @block)
    @proxy = "proxy"
    stub(@proxy).set
    @attr.add_to(@proxy)
    @proxy.should have_received.set(:user, @proxy)
  end

  it "should yield the proxy and factory parameters to the block when adding its value to a proxy" do
    @block = lambda {|a, arg1, arg2| a }
    @attr  = FactoryGirl::Attribute::Dynamic.new(:user, @block)
    @proxy = "proxy"
    stub(@proxy).set
    mock(@proxy).production_parameters {['test-param1', 'test-param2']}
    mock(@block).call(@proxy, 'test-param1', 'test-param2') {'expected value'}

    @attr.add_to(@proxy)
  end

  it "should raise an error when defining an attribute writer" do
    lambda {
      FactoryGirl::Attribute::Dynamic.new('test=', nil)
    }.should raise_error(FactoryGirl::AttributeDefinitionError)
  end

  it "should raise an error when returning a sequence" do
    stub(Factory).sequence { FactoryGirl::Sequence.new }
    block = lambda { Factory.sequence(:email) }
    attr = FactoryGirl::Attribute::Dynamic.new(:email, block)
    proxy = stub!.set.subject
    stub(proxy).production_parameters
    lambda {
      attr.add_to(proxy)
    }.should raise_error(FactoryGirl::SequenceAbuseError)
  end

  it "should convert names to symbols" do
    FactoryGirl::Attribute::Dynamic.new('name', nil).name.should == :name
  end
end
