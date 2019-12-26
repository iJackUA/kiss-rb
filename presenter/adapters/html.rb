require_relative './adapter.rb'

class Kiss::Presenter::Adapter::HTML < Kiss::Presenter::Adapter
  def initialize(opts)
    super
    @tpl = opts[:tpl]
  end

  def to_s(presenter)
    sprintf(@tpl, presenter.resolve_attributes)
  end
end
