require 'spec_helper'

describe SvmPredictor::Model do
  IMPORTANT_ATTRS = [
                      :classification,
                      :dictionary,
                      :id,
                      :libsvm_file,
                      :preprocessor_class,
                      :preprocessor_properties,
                      :selector_class,
                      :selector_properties,
                      :properties
                    ]
  let(:modelhash) do
    {
      id: 1,
      libsvm_file: "0001-model.libsvm",
      classification: :function,
      preprocessor_class: Preprocessor::Simple.to_s,
      selector_class: Selector::Simple.to_s,
      trainer_class: "String",
      dictionary: %w(foo bar baz blub meh),
      selector_properties: {},
      preprocessor_properties: {},
      properties: { dictionary_size: 5, cost: 10.0, gamma: 0.0},
      metrics: { overall: 0.76, geometric_mean: 0.77, histogram: [[65,0.6],[75,0.7],[85,0.8]] },
      created_at: [27, 41, 14, 13, 3, 2013, 3, 72, false, "CET"]
    }
  end
  before(:all) do
    problem = Libsvm::Problem.new
    parameter = Libsvm::SvmParameter.new
    parameter.c = 10
    parameter.probability = 1
    examples = [ [1,0,1], [-1,0,-1] ].map {|ary| Libsvm::Node.features(ary) }
    problem.set_examples([1,-1], examples)
    @svm = Libsvm::Model.train(problem, parameter)
  end

  let(:model) do
    SvmPredictor::Model.new svm: @svm,
                            preprocessor: Preprocessor::Simple.new,
                            selector: Selector::Simple.new(:function, global_dictionary: modelhash[:dictionary]),
                            classification: :function,
                            basedir: 'tmp/spec'
  end
  it "should be able to serialize the model" do
    ->{model.serializable_hash}.should_not raise_error
  end
  context "#serializable_hash" do
    it "should include all important attributes" do
      model.serializable_hash.keys.should include(*IMPORTANT_ATTRS)
    end

    IMPORTANT_ATTRS.each do |attr|
      it "should correct serialize #{attr}" do
        model.serializable_hash[attr].should == modelhash[attr]
      end
    end
    it "sould set created at to Time.now" do
      Timecop.freeze
      model.serializable_hash[:created_at].should == Time.now.to_s
    end
  end
  context "#next_id" do
    it "should start with 1 if folder is empty" do
      model.send(:next_id).should == 1
    end
    it "should select the next available id" do
      FileUtils.touch('tmp/spec/23-foo')
      model.send(:next_id).should == 24
    end
  end
  context '#save' do
    it "should assign a id to the model" do
      model.id = nil
      model.expects(:next_id).returns(345)
      model.save
    end
    it "should fail if basedir is nil" do
      model.basedir = nil
      -> {model.save}.should raise_error
    end
    it "should fail if basedir is empty" do
      model.basedir = ''
      -> {model.save}.should raise_error
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
  context "#load" do
    before(:each) do
      @svm.save('tmp/spec/345-model.libsvm')
    end
    it "should not fail" do
      ->{SvmPredictor::Model.load(modelhash.merge(basedir: 'tmp/spec'))}.should_not raise_error
    end
  end
  context "#predict" do
    it "should not fail" do
      ->{model.predict("title", "description words foo", 4)}.should_not raise_error
    end
    it "should return either 0 or 1 for the label" do
      label,_ = model.predict("title", "description words foo", 4)
      [false, true].should include(label)
    end
    it "should return a value between 0.5 and 1.0 for probability" do
      _, probability = model.predict("title", "description words foo", 4)
      probability.should be_between(0.5,1.0)
    end
  end
end
