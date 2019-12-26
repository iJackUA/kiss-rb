require_relative './presenter'
require_relative './adapters/html'
require_relative './adapters/json'

# INPUT DATA

# Just an Object Data Model with attibutes
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
  output_adapter Adapter::HTML, tpl: '<html><head></head><body><h1> %<full_name>s / Created: %<created_at>s </h1> Email: %<email>s </body></html>'

  def attributes
    {
      full_name: { getter: :full_name },
      email: RAW_ATTRIBUTE_VALUE,
      created_at: { getter: :created_at }
    }
  end

  def full_name
    "User name is #{model.last_name} #{model.first_name}"
  end

  def created_at
    'NO DATA'
  end
end

class JsonUserPresenter < Kiss::Presenter
  output_adapter Adapter::JSON

  def attributes
    {
      full_name: { getter: :full_name },
      email: RAW_ATTRIBUTE_VALUE,
      created_at: { getter: :created_at }
    }
  end

  def full_name
    "#{model.first_name} #{model.last_name}"
  end

  def created_at
    model.created_at.strftime('%Y%jT%H%M%S%z')
  end
end

### OUTPUT TEST
user_data = {
  first_name: 'John',
  last_name: 'Snow',
  email: 'j.snow@got.com',
  created_at: Time.new(2001, 10, 12)
}
user = UserModel.new(user_data)

puts '-----------------------'

html_user = HtmlUserPresenter.new(user).to_s
puts 'HTML user presentation'
puts html_user

puts '-----------------------'

json_user = JsonUserPresenter.new(user).to_s
puts 'JSON user presentation'
puts json_user

