require 'active_support/concern'
require 'active_support/core_ext/class/inheritable_attributes'
require 'fastercsv' unless RUBY_VERSION  >= "1.9"

module ToCsv
  extend ActiveSupport::Concern

  included do 
    class_inheritable_accessor :csv_instructions
    self.csv_instructions = Hash.new({})
  end

  class Interceptor
    def initialize(object,block=nil) 
      @object = object
      @block  = block
      @result = []
      @method_audit = []
    end

    def self.from(object)
      new(object)
    end

    def to_block(&block)
      @block = block
      self
    end

    def with_result
      yield instance_eval(&@block), @method_audit
    end

    def method_missing(sym,*args,&block)
      @method_audit << sym
      @result       << @object.send(sym,*args,&block)
    end
  end

  module ClassMethods
    def csv(namespace=:default,&block)
      csv_instructions[namespace] = block
    end
  end

  def to_csv(namespace = :default)
    Interceptor.from(self).to_block(&csv_instructions[namespace]).with_result do |result,methods|
      FasterCSV::generate_line(result)
    end
  end

  def to_csv_header(namespace = :default)
    Interceptor.from(self).to_block(&csv_instructions[namespace]).with_result do |result,methods|
      FasterCSV::generate_line(methods)
    end
  end
end
