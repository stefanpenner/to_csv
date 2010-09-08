module ToCsv
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
      instance_eval(&@block)
      yield @result, @method_audit
    end

    def method_missing(sym,*args,&block)
      @method_audit << sym
      result       = @object.send(sym,*args,&block)
      @result      << result
      result
    end
  end
end
