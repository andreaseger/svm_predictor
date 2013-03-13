require 'json'

module SvmPredictor
  class Base
    attr_accessor :id
    @@_attributes = Hash.new { |hash, key| hash[key] = [] }
    def self.attribute *attr
      attr.each do |name|
        define_method(name) do
          @_attributes[name]
        end
        define_method(:"#{name}=") do |v|
          @_attributes[name] = v
        end
        attributes << name unless attributes.include? name
      end
    end
    def serializable_hash
      @_attributes.merge(id: @id)
    end
    def to_json
      serializable_hash.to_json
    end

    def save
      raise "Not yet implemented"
    end
    def self.load(params)
      new params
    end
    def initialize(params={})
      @_attributes = {}
      @id = nil
      params.each do |key, value|
        send("#{key}=", value)
      end
    end
    private
    def self.attributes
      @@_attributes[self]
    end
    def attributes
      self.class.attributes
    end
  end
end