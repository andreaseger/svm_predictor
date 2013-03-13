require 'spec_helper'

describe Predictor::Model do
  let(:modelhash) do
    {
      id: 443
      model_file: "meh.model",
      classification: :function,
      preprocessor_class: "Integer",
      selector_class: "Float",
      trainer_class: "String",
      dictionary: %w(foo bar baz blub meh),
      selector_properties: nil,
      preprocessor_properties: {},
      properties: { dictionary_size: 5, gamma: 34, cost: 5 },
      metrics: { overall: 0.76, geometric_mean: 0.77, histogram: [[65,0.6],[75,0.7],[85,0.8]] },
      created_at: [27, 41, 14, 13, 3, 2013, 3, 72, false, "CET"]
    }
  end

  context 'instance' do
    let(:model) do
      model = Predictor::Model.new modelhash
    end
    context "#next_id" do
      
    end
    con
    context '#save' do
      it "should assign a id to the model" do
        model.id = nil
        model.expects(:next_id).returns(345)
        model.save
      end
      it "should serialize the attributes" do
        model.expects(:serializable_hash).returns(modelhash)
        model.save
      end
      it "should make json out of the attributes" do
        model.expects(:to_json).returns(modelhash.to_json)
        model.save
      end
    end
  end
end