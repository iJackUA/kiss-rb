module Kiss
  class Presenter
    RAW_ATTRIBUTE_VALUE = 0

    attr_accessor :model

    class << self
      attr_accessor :adapter_class, :adapter_opts
    end

    def self.output_adapter(adapter_class, opts = {})
      @adapter_class = adapter_class
      @adapter_opts = opts
    end

    def initialize(model)
      @model = model
    end

    def to_s
      self.class.adapter_class.new(self.class.adapter_opts).to_s(self)
    end

    def attributes
      {}
    end

    def attribute(attr_name)
      attr_opts = attributes[attribute_name]
      resolve_attribute(attr_name, attr_opts)
    end

    def resolve_attribute(attr_name, attr_opts)
      Attribute.new(attr_name, attr_opts).value(self)
    end

    def resolve_attributes
      attributes.inject({}) do |result, (key, value)|
        result[key] = resolve_attribute(key, value)
        result
      end
    end

    class Attribute
      def initialize(name, opts)
        @name = name
        @opts = opts
      end

      def value(context)
        if @opts == ::Kiss::Presenter::RAW_ATTRIBUTE_VALUE
          context.model.send(@name)
        elsif @opts.is_a? Hash
          getter = @opts[:getter]
          context.send(getter)
        end
      end
    end

  end
end
