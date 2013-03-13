require 'spec_helper'

class MockModel < SvmPredictor::Base
  attribute :body, :title, :created_at
end

describe SvmPredictor::Base do
  #it_should_behave_like "ActiveModel"
  let(:modelhash) do
    { body: "Lorem Ipsum", title: "some test", created_at: nil }
  end

  context 'class' do
    context "#load" do
      it "should call new" do
        MockModel.expects(:new).with(modelhash)
        MockModel.load modelhash
      end
    end
    context '#new' do
      it 'should create accessors for all hash key/value pairs' do
        model = MockModel.new modelhash
        model.body.should == modelhash[:body]
        model.title.should == modelhash[:title]
      end
    end
  end

  context 'instance' do
    let(:model) do
      model = MockModel.new modelhash
    end
    context "#serializable_hash" do
      it "should create a hash from the attributes" do
        model.serializable_hash.should be_a(Hash)
      end
      it "should include all attributes" do
        model.serializable_hash.should == modelhash.merge(id: nil)
      end
    end
  end
end
