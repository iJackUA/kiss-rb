require_relative './adapter.rb'
require 'json'

class Kiss::Presenter::Adapter::JSON < Kiss::Presenter::Adapter
  def to_s(presenter)
    ::JSON.generate(presenter.resolve_attributes)
  end
end
