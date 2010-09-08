require 'active_support/concern'
require 'active_support/core_ext/class/inheritable_attributes'
require 'fastercsv' unless RUBY_VERSION  >= "1.9"
require 'to_csv/interceptor'

module ToCsv
  extend ActiveSupport::Concern

  included do 
    class_inheritable_accessor :csv_instructions
    self.csv_instructions = Hash.new({})
  end

  module ClassMethods
    def csv(namespace=:default,&block)
      csv_instructions[namespace] = block
    end
  end

  def to_csv(namespace = :default)
    Interceptor.from(self).to_block(&csv_instructions[namespace]).with_result do |results,methods|
      FasterCSV::generate_line(results)
    end
  end

  def to_csv_header(namespace = :default)
    Interceptor.from(self).to_block(&csv_instructions[namespace]).with_result do |results,methods|
      FasterCSV::generate_line(methods)
    end
  end
end

