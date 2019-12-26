class Kiss::Presenter::Adapter
  def initialize(opts)
    @opts = opts
  end

  def to_s(presenter)
    raise StandardError 'Adapter method `to_s` is not implemented'
  end
end
