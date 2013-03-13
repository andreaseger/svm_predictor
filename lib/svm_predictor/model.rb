require_realive 'base'
require "active_support/inflector"

module SvmPredictor
  class Model < SvmPredictor::Base
    BASEDIR = File.expand_path(File.dirname(__FILE__) + '../../results')
    attribute :libsvm_file,
              :classification,
              :preprocessor_class,
              :selector_class,
              :trainer_class,
              :dictionary,
              :selector_properties,
              :preprocessor_properties,
              :properties,
              :metrics,
              :created_at
    attr_accessor :svm,
                  :preprocessor,
                  :selector

    #
    # predict the label w/ probability of a given job
    # @param  job [Job]
    #
    # @return [Integer,Double] label as Integer and the probability of this label
    def predict title, description, classification
      data = preprocessor.process(job, classification)
      features = Libsvm::Node.features(selector.generate_vector(data, classification).data)

      label, probs = svm.predict_probability(features)
      # TODO find a more reliable way to find the correct probability value for the given label
      # but nevertheless this should be correct
      return label, probs.max
    end

    def created_at
      Time.mktime *super
    end
    def save
      prepare_model
      self.libsvm_file, filename = filenames
      self.created_at = Time.now.to_a
      svm.save(File.join(BASEDIR, model_file))
      IO.save(File.join(BASEDIR, filename), self.to_json)
    end

    def self.load_file(filename)
      load_json IO.read(filename)
    end
    def self.load_json(json)
      load JSON.parse(json)
    end
    def self.load(params)
      p = super
      p.svm = Libsvm::Model.load(p.libsvm_file)
      p.preprocessor = p.preprocessor_class.constantize.new(p.preprocessor_properties)
      p.selector = p.selector_class.constantize.new(p.selector_properties.merge( global_dictionary: p.dictionary, classification: p.classification))
      p
    end

    def initialize(params={})
      super
      self.preprocessor_properties ||= {}
      self.selector_properties ||= {}
      self.properties ||= {}
    end
    private
    def prepare_model
      self.id ||= next_id
      self.preprocessor_class ||= preprocessor.class.to_s
      self.selector_class ||= preprocessor.class.to_s
      self.dictionary ||= selector.global_dictionary
      self.preprocessor_properties.merge!(industry_map: preprocessor.industry_map ) if preprocessor.respond_to? :industry_map
      self.selector_properties.merge!(gram_size: selector.gram_size ) if selector.respond_to? :gram_size
      self.properties.merge!(dictionary_size: dictionary.size, cost: svm.param.cost, gamma: svm.param.gamma)
    end
    def filenames
      [ "#{id}-model.libsvm", "#{id}-predictor.json" ]
    end
    def next_id
      #TODO
      345
    end
  end
end