require_relative 'base'
require 'time'
require "active_support/inflector"
require "active_support/core_ext/hash"

module SvmPredictor
  class Model < SvmPredictor::Base
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
                  :selector,
                  :basedir

    #
    # predict the label w/ probability of a given job
    # @param  job [Job]
    #
    # @return [Integer,Double] label as Integer and the probability of this label
    def predict title, description, classification_id
      # TODO job = create_job(title, description, classification_id)
      #   or preprocessor.process(title, description, classification_id, classification)
      #   or something like that
      #   maybe even change preprocessor and selector interface because the current one makes not sense
      job = {title: title, description: description, id: classification_id}
      data = preprocessor.process(job)
      features = Libsvm::Node.features(selector.generate_vector(data).data)

      label, probs = svm.predict_probability(features)
      # TODO find a more reliable way to find the correct probability value for the given label
      # but nevertheless this should be correct
      return !label.zero?, probs.max
    end

    def created_at
      Time.parse @_attributes[:created_at] unless @_attributes[:created_at].nil?
    end
    def serializable_hash
      prepare_model
      super
    end
    def save
      raise 'basedir not specified' if basedir.nil? || basedir.empty?
      prepare_model
      svm.save(File.join(basedir, libsvm_filename))
      IO.write(File.join(basedir, filename), self.to_json)
    end

    def self.load_file(filename)
      load_json IO.read(filename), File.dirname(File.expand_path(filename))
    end
    def self.load_json(json, basedir)
      load JSON.parse(json).merge(basedir: basedir)
    end
    def self.load(params)
      p = super
      p.svm = Libsvm::Model.load(File.join(p.basedir, p.libsvm_file))
      p.preprocessor = if p.preprocessor_class =~ /mapping/i
                        id_map = Hash[p.preprocessor_properties['id_map']]
                        p.preprocessor_class.constantize.new(id_map, {parallel: true}.merge(p.preprocessor_properties.except('id_map')))
                      else
                        p.preprocessor_class.constantize.new({parallel: true}.merge(p.preprocessor_properties))
                      end
      p.selector = p.selector_class.constantize.new(p.classification.to_sym, {parallel: true, global_dictionary: p.dictionary}.merge(p.selector_properties))
      p
    end

    def initialize(params={})
      super
      self.preprocessor_properties ||= {}
      self.selector_properties ||= {}
      self.properties ||= {}
    end
    def results_filename
      "#{"%04d" % id}-results"
    end
    private
    def prepare_model
      self.id ||= next_id
      self.created_at ||= Time.now.to_s
      self.libsvm_file ||= libsvm_filename
      self.preprocessor_class ||= preprocessor.class.to_s
      self.selector_class ||= selector.class.to_s
      self.dictionary ||= selector.global_dictionary
      self.preprocessor_properties.merge!(id_map: preprocessor.id_map.to_a ) if preprocessor.respond_to? :id_map
      self.selector_properties.merge!(gram_size: selector.gram_size ) if selector.respond_to? :gram_size
      self.properties.merge!(dictionary_size: dictionary.size, cost: svm.param.c, gamma: svm.param.gamma)
    end
    def libsvm_filename
      "#{"%04d" % id}-model.libsvm"
    end
    def filename
      "#{"%04d" % id}-predictor.json"
    end
    def next_id
      raise 'basedir not specified' if basedir.nil?
      (Dir["#{@basedir}/*"].map{|e| File.basename(e).match(/^(\d+)-/)[1].to_i }.max || 0).succ
    end
  end
end
