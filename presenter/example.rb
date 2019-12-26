module Kiss
  class Presenter
    attr_accessor :model
    class << self
      attr_accessor :adapter_class, :adapter_opts
    end

    def self.adapter(adapter_class, opts = {})
      @adapter_class = adapter_class
      @adapter_opts = opts
    end

    def initialize(model)
      @model = model
    end

    def to_s
      self.class.adapter_class.new(self.class.adapter_opts).to_s(self)
    end

    class Adapter
      def initialize(opts)
        @opts = opts
      end

      def to_s(presenter)
        raise StandardError 'Adapter method `to_s` is not implemented'
      end

      def attributes
        {}
      end

      def attr(attribute_name)
        attributes[attribute_name]
      end

      class JSON < Adapter
        require 'json'

        def to_s(presenter)
          puts 'DM'
          puts presenter.model
          ::JSON.generate({e: presenter.model.email})
        end
      end

      class HTML < Adapter
        def initialize(opts)
          super
          @tpl = opts[:tpl]
        end

        def to_s(presenter)
          sprintf(@tpl, {full_name: presenter.model.first_name, email: presenter.model.email, created_at: presenter.model.created_at})
        end
      end
    end
  end
end

# INPUT DATA

class UserModel
  attr_accessor :first_name, :last_name, :email, :created_at

  def initialize(first_name:,last_name:, email:, created_at:)
    @first_name = first_name
    @last_name = last_name
    @email = email
    @created_at = created_at
  end
end

### PRESENTERS USAGE EXAMPLE

class HtmlUserPresenter < Kiss::Presenter
  adapter Adapter::HTML, tpl: '<html><head></head><body><h1> %<full_name>s / Created: %<created_at>s </h1> Email: %<email>s </body></html>'

  def full_name
    "User name is #{model.last_name} #{model.first_name}"
  end
end

class JsonUserPresenter < Kiss::Presenter
  adapter Adapter::JSON

  def attributes
    {
      full_name: { getter: :full_name },
      email: { form: email }
    }
  end

  def full_name
    "#{model.first_name} #{model.last_name}"
  end
end

### OUTPUT

user = UserModel.new first_name: 'John', last_name: 'Snow', email: 'j.snow@got.com', created_at: Time.new(2001, 10, 12)

html_user = HtmlUserPresenter.new(user).to_s
json_user = JsonUserPresenter.new(user).to_s

puts 'HTML user presentation'
puts html_user

puts '-----------------------'

puts 'JSON user presentation'
puts json_user

