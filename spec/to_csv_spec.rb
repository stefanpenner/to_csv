require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Email
  include ToCsv
  attr_accessor :name, :data, :some_boolean

  csv do
    name
    data
    some_boolean
  end

  csv :just_name do
    name
  end

  def initialize(name,data,some_boolean)
    @name = name
    @data = data
    @some_boolean = some_boolean
  end
end


describe ToCsv do
  before(:each) do
    @email = Email.new("Stefan Penner","asdf asdf", true)
  end

  it "drops default CSV set to csv" do
    @email.to_csv.should match("Stefan Penner,asdf asdf,true\n")
  end

  describe "to_csv" do
    it "without params should match with params of :default" do
      @email.to_csv.should match(@email.to_csv(:default))
    end
  end

  describe "to_csv_header" do
    it "display the default methods called, in the call order" do
      @email.to_csv_header.should match("name,data,some_boolean")
    end
  end

  it "drop just_name CSV set to csv" do
    @email.to_csv(:just_name).should match("Stefan Penner")
  end
end
