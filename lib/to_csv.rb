require 'active_support/concern'
require 'active_support/core_ext/class/inheritable_attributes'
require 'fastercsv' unless RUBY_VERSION  >= "1.9"

module ToCsv
  extend ActiveSupport::Concern

  included do 
    class_inheritable_accessor :csv_instructions
    self.csv_instructions = Hash.new({})
  end

  class CSVProxy
    def initialize(object,block=nil) 
      @object = object
      @block  = block
      @result = []
    end

    def to_csv
      FasterCSV::generate_line(instance_eval &@block)
    end

    def method_missing(sym,*args,&block)
      @result << @object.send(sym)
    end
  end

  module ClassMethods
    def csv(namespace=:default,&block)
      csv_instructions[namespace] = block
    end
  end

  def to_csv(namespace = :default)
    CSVProxy.new(self,csv_instructions[namespace]).to_csv
  end
end
